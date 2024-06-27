import pandas as pd
import os
from tkinter import Tk, Label, Button, Entry, filedialog, messagebox

class ExcelComparerApp:
    def __init__(self, master):
        self.master = master
        self.master.title("Excel Comparer")
        
        # Labels and Entries for file paths
        self.label1 = Label(master, text="First Excel file:")
        self.label1.grid(row=0, column=0, sticky="w")
        self.entry1 = Entry(master, width=50)
        self.entry1.grid(row=0, column=1)
        self.button1 = Button(master, text="Browse", command=self.browse_file1)
        self.button1.grid(row=0, column=2)
        
        self.label2 = Label(master, text="Second Excel file:")
        self.label2.grid(row=1, column=0, sticky="w")
        self.entry2 = Entry(master, width=50)
        self.entry2.grid(row=1, column=1)
        self.button2 = Button(master, text="Browse", command=self.browse_file2)
        self.button2.grid(row=1, column=2)
        
        self.label3 = Label(master, text="Output CSV file:")
        self.label3.grid(row=2, column=0, sticky="w")
        self.entry3 = Entry(master, width=50)
        self.entry3.grid(row=2, column=1)
        self.button3 = Button(master, text="Browse", command=self.browse_output_file)
        self.button3.grid(row=2, column=2)

        # Compare and save button
        self.compare_button = Button(master, text="Compare and Save", command=self.compare_and_save)
        self.compare_button.grid(row=3, column=1, pady=10)

    def browse_file1(self):
        filename = filedialog.askopenfilename(filetypes=[("Excel files", "*.xlsx;*.xls")])
        self.entry1.insert(0, filename)
        
    def browse_file2(self):
        filename = filedialog.askopenfilename(filetypes=[("Excel files", "*.xlsx;*.xls")])
        self.entry2.insert(0, filename)

    def browse_output_file(self):
        filename = filedialog.asksaveasfilename(defaultextension=".csv", filetypes=[("CSV files", "*.csv")])
        self.entry3.insert(0, filename)

    def load_excel(self, file_path):
        """
        Load Excel file into a DataFrame.
        """
        try:
            df = pd.read_excel(file_path)
            return df
        except Exception as e:
            messagebox.showerror("Error", f"Error loading {file_path}: {e}")
            return None

    def compare_and_combine(self, df1, df2):
        """
        Compare dataframes and combine them. Return a new dataframe.
        """
        # Find rows in df1 that are not in df2
        missing_rows = df1[~df1.apply(tuple, 1).isin(df2.apply(tuple, 1))]
        
        # Concatenate missing rows from df1 and all rows from df2
        combined_df = pd.concat([missing_rows, df2]).reset_index(drop=True)
        return combined_df

    def save_to_csv(self, df, output_path):
        """
        Save DataFrame to CSV.
        """
        try:
            df.to_csv(output_path, index=False)
            messagebox.showinfo("Success", f"Combined data saved to {output_path}")
        except Exception as e:
            messagebox.showerror("Error", f"Error saving CSV: {e}")

    def compare_and_save(self):
        # Get file paths from entries
        file1 = self.entry1.get()
        file2 = self.entry2.get()
        output_file = self.entry3.get()

        # Load the Excel files
        df1 = self.load_excel(file1)
        df2 = self.load_excel(file2)

        if df1 is not None and df2 is not None:
            # Compare and combine the dataframes
            combined_df = self.compare_and_combine(df1, df2)
            
            # Save the combined dataframe to CSV
            self.save_to_csv(combined_df, output_file)
        else:
            messagebox.showerror("Error", "Unable to load one or both of the Excel files. Please check the file paths and try again.")

if __name__ == "__main__":
    root = Tk()
    app = ExcelComparerApp(root)
    root.mainloop()
