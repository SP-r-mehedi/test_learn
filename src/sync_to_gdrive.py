# upload_to_drive.py
import os
import json
import google.auth
from google.auth.transport.requests import Request
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.http import MediaFileUpload

def upload_to_drive(service_account_json, file_path, folder_id):
    # Load the service account credentials
    credentials = service_account.Credentials.from_service_account_file(
        service_account_json, scopes=["https://www.googleapis.com/auth/drive.file"])

    # Build the Google Drive API client
    drive_service = build('drive', 'v3', credentials=credentials)

    # Specify the file metadata
    file_metadata = {
        'name': os.path.basename(file_path),
        'parents': [folder_id]
    }

    media = MediaFileUpload(file_path, mimetype='text/markdown')

    # Create and upload the file
    file = drive_service.files().create(
        body=file_metadata,
        media_body=media,
        fields='id'
    ).execute()

    print(f"Uploaded {file_path} to Google Drive with ID: {file['id']}")

if __name__ == "__main__":
    # Set the Google service account JSON path and folder ID
    service_account_json = 'service_account.json'  # Path to the service account JSON
    file_path = 'README.md'  # Path to the file you want to upload
    folder_id = '1tSEQGxJVkPZTYdGbDJtqGrqC8FQ9bnYD'  # Your Google Drive folder ID

    upload_to_drive(service_account_json, file_path, folder_id)
