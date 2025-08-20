
import pandas as pd
import os

def merge_files(gene_dir, protein_dir):
    starting_files = [
        filename
        for filename in os.listdir(gene_dir)
        if filename.endswith(".geni.filtered.faa.csv")
    ]

    for file in starting_files:
        # Construct the full path for the gene file
        gene_path = os.path.join(gene_dir, file)
        # Load the gene data file
        df_gene = pd.read_csv(gene_path)

        # Construct the matching protein file name and path
        base_filename = ".".join(file.split(".")[:3])  # This strips the file to the common base
        protein_filename = base_filename + '.proteine.filtered.faa.parsed.csv'
        protein_path = os.path.join(protein_dir, protein_filename)
        # Load the protein data file
        df_protein = pd.read_csv(protein_path)

        # Merge the dataframes based on shared columns
        # Adjust as necessary if 'header' alone is sufficient and uniquely identifies each contig
        merged_df = pd.merge(df_gene, df_protein, on=['header', 'length', 'gc_content'],
                             suffixes=('_gene', '_protein'))

        # Drop unwanted columns, specify the exact column names to remove
        columns_to_drop = ['sample_gene']  # Adjust the column names based on your specific needs
        merged_df.drop(columns=columns_to_drop, inplace=True)

        # Rename 'sample_protein' column to 'sample_name'
        merged_df.rename(columns={'sample_protein': 'sample_name'}, inplace=True)

        # Create a directory for the merged output if it doesn't exist
        output_folder = os.path.join("MergedDataFramesV2", file.split(".")[0])
        os.makedirs(output_folder, exist_ok=True)
        # Save the merged dataframe to a new CSV file
        output_filename = f"{base_filename}.csv"
        output_path = os.path.join(output_folder, output_filename)
        merged_df.to_csv(output_path, index=False)

# Example usage of the function
merge_files("C:\\Users\\Utente\Desktop\\pythonProject\\GenomeDatabase\\genes",
            "C:\\Users\\Utente\\Desktop\\pythonProject\\GenomeDatabase\\proteins")