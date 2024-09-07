# abi_parser.py

def clean_abi(input_file, output_file):
    with open(input_file, 'r') as file:
        abi = file.read()
    
    # Remove all whitespaces (spaces, tabs, newlines)
    cleaned_abi = ''.join(abi.split())
    
    # Write the cleaned ABI to the output file
    with open(output_file, 'w') as file:
        file.write(cleaned_abi)
    
    print(f"Cleaned ABI saved to {output_file}")

if __name__ == "__main__":
    input_file = "contract_abi.json"
    output_file = "cleaned_contract_abi.json"
    
    clean_abi(input_file, output_file)
