import os
import csv


class ReadGenomeFiles:

    def __init__(self):
        pass

    @staticmethod
    def convertGenomeFileToCSV(payload: dict):
        """

        ------ Function Description ------ :

        This class method can be used to read the reconstructed genome files
        to Comma Separated Values file. It takes a input payload in dictionary format.

         ------ Function Argument Description ------

        payload = {sample:filename}
        - sample : The sample the reconstructed genome is coming from.
        -filename: The name of the reconstructed genome file.

        ------ Output file description ------

        The final output file will have the following headers(columns names):
        - header : Starts with >NODE and some metadata related to the reconstructed genomes.
        -length : Value extracted from the header metadata.
        - gc_content : Value extracted from the header metadata.
        - nucleotide_sequence: This will contain the nucleotide if the reconstructed genome is a gene file.
        - sequence: This will contain the amino acid sequence if the reconstructed genome is a protein.
        - sample : This represents the sample the genome was reconstructed from.

        When the method is called, it creates two directories to store the output files:
        - genes directory: This will store all the reconstructed genomes (gene version).
        - protein directory: This will store all the reconstructed genomes (protein versions).

        """

        # This will contain a list of the sequences from each contig in the input reconstructed genome file.
        sequences = []

        # Unpack the payload to obtain the name of the sequence and the filename to process
        for sample, filename in payload.items():
            # The resulting CSV will either be stored in a protein or gene directory.
            outputDirectory = "proteins" if "protein" in filename else "genes"

            # These represent the column headers in the CSV file and the column at index -2 will change depending.
            # on the type of file the is going to be processed.
            columns = [
                "header",
                "length",
                "gc_content",
                (
                    "amino_acid_sequence"
                    if "protein" in filename
                    else "nucleotide_sequence"
                ),
                "sample",
            ]

            # The directory where the CSV file will be store will be created only if it does not exist already.
            os.makedirs(outputDirectory, exist_ok=True)

            # This will open each input file using the context-manager and begin processing the file.
            with open(filename, "r") as file:

                # Initialized to None
                sequenceMetadata = None

                # Initialized as an empty string.
                sequence = ""

                # Loop through every line in the input file.
                for line in file:

                    # Eliminate white spaces
                    line = line.strip()

                    # Check if the line starts with the expected header string (>NODE).
                    if line.startswith(">NODE"):

                        # If the sequence metadat has already been set, append to our sequences list
                        # with the associated sequence.This will happen if a file has already been processed.
                        if sequenceMetadata is not None:
                            sequences.append((sequenceMetadata, sequence))

                        # Properly format the header to remove white spaces.
                        sequenceMetadata = " ".join(line.split()[:]).replace(" ", "")

                        # Reset protein sequence
                        sequence = ""
                    else:
                        sequence += line

                # Append the last protein sequence
                if sequenceMetadata is not None:
                    sequences.append((sequenceMetadata, sequence))

            # This block will determine what the final output file name will be and the sub-folder. This is too messy
            # and requires refactoring but for now, I'll leave it as it is. It works as-is so all good for me.

            # Example:
            # /Users/sdason/Desktop/GenomeDatabase/shotgun_data/10AD-12m_S12_Buone_R1.fastq/reconstructedgenomes.9.fa.proteine.filtered.faa.parsed.txt

            finalFileName = (
                f"{outputDirectory}/{'-'.join(filename.split('/')[-2:]).replace('_Buone_R1.fastq', '').replace('.txt', '.csv')}"
                if filename.__contains__("protein")
                else f"{outputDirectory}/{'-'.join(filename.split('/')[-2:]).replace('_Buone_R1.fastq', '')}.csv"

            )

            # Block of code to write to file.
            with open(finalFileName, "w", newline="") as csvfile:
                fieldnames = columns
                writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
                writer.writeheader()
                sequence_type = columns[-2]

                # This is what an entry (contig) in the sequence list looks like:
                #
                sampleColValue = sample.replace("_Buone_R1.fastq", "")
                for contig in sequences:
                    writer.writerow(
                        {
                            "header": contig[0],
                            "length": contig[0].split(";")[0].split("_")[3],
                            "gc_content": contig[0].split(";")[-1].split("=")[-1],
                            sequence_type: contig[1],
                            "sample": sampleColValue,
                        }
                    )

        # Returns the sequences
        return sequences


# Smoke Test
if __name__ == "__main__":

    def main(baseDirectory):
        task = ReadGenomeFiles

        directories = [
            dir for dir in os.listdir(baseDirectory) if not dir.startswith(".")
        ]

        for sample_dir in os.listdir(baseDirectory):
            path = f"{baseDirectory}/{sample_dir}"
            print(f"Checking path: {path}")  # Debugging print
            if os.path.isdir(path):
                for filename in os.listdir(path):
                    print(f"Processing file: {filename} in directory: {path}")
                    # ... (process the file)
            else:
                print(f"Skipping non-directory path: {path}")

        for sample_dir in directories:
            geneFilePayloads = [
                # This will be the function payload dict containing the sample directory and the filename.
                {sample_dir: f"{baseDirectory}/{sample_dir}/{filename}"}
                for filename in os.listdir(f"{baseDirectory}/{sample_dir}")
                if filename.endswith(".geni.filtered.faa")
            ]

            for genePayload in geneFilePayloads:
                # print("Gene Payload: ", genePayload, end=">>>>>>>>>>>>>>>>>")
                task.convertGenomeFileToCSV(genePayload)

            # REFACTOR HERE
            proteinFilePayloads = [
                # This will be the function payload dict containing the sample directory and the filename.
                # This is a bit messy. Requires refactoring. The class method could be refactored to deduce sample_dir.
                {sample_dir: f"{baseDirectory}/{sample_dir}/{filename}"}
                for filename in os.listdir(f"{baseDirectory}/{sample_dir}")
                if filename.endswith(".proteine.filtered.faa.parsed.txt")
            ]

            # REFACTOR HERE
            for proteinPayload in proteinFilePayloads:
                # print("Protein Payload: ", proteinPayload, end=">>>>>>>>>>>>>>>>>")
                task.convertGenomeFileToCSV(proteinPayload)


    print(os.getcwd())

# Run Test Function
    main("C://Users//Utente//Desktop//pythonProject//GenomeDatabase")


