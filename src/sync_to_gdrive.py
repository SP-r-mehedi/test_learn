import os
from google.oauth2.service_account import Credentials
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

# Load credentials
service_account_info = os.getenv('GOOGLE_APPLICATION_CREDENTIALS_JSON')
credentials = Credentials.from_service_account_info(service_account_info)

service = build('drive', 'v3', credentials=credentials)

# Folder ID and file list to upload
folder_id = '1tSEQGxJVkPZTYdGbDJtqGrqC8FQ9bnYD'
file_paths = ['list', 'of', 'file', 'paths']  # Adjust this list as needed

def upload_file(file_path, folder_id):
    file_metadata = {
        'name': os.path.basename(file_path),
        'parents': [folder_id]
    }
    media = MediaFileUpload(file_path, resumable=True)
    file = service.files().create(body=file_metadata, media_body=media, fields='id').execute()
    print(f"Uploaded {file_path} to Google Drive with ID {file['id']}")

for file_path in file_paths:
    upload_file(file_path, folder_id)

if __name__ == '__main__':
    for file_path in file_paths:
        upload_file(file_path, folder_id)
