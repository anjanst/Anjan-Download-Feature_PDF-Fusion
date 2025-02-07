require "docx"
class DocumentsController < ApplicationController
  before_action :set_document, only: [ :show, :destroy ] # Removed :update, since you're not using it

  # GET /documents
  def index
    @documents = Document.all
  end

  # GET /documents/new
  def new
    @document = Document.new
  end

  # POST /documents
  def create
    @document = Document.new(document_params)

    if @document.save
      redirect_to documents_path, notice: "Document was successfully uploaded."
    else
      render :new
    end
  end

  # GET /documents/:id
  def show
  end

  # DELETE /documents/:id
  def destroy
    @document.destroy
    redirect_to documents_url, notice: "Document was successfully deleted."
  end

  # Custom download action with filename based on first content inside the docx
  def download
    document = Document.find(params[:id])

    # Ensure file exists
    if document.file.attached?
      # Get the original file name without extension
      original_name = File.basename(document.file.filename.to_s, ".*")

      # Download and extract text from the docx file
      file_path = ActiveStorage::Blob.service.path_for(document.file.key)
      doc = Docx::Document.open(file_path)

      # Extract first content (assuming the first paragraph is the username)
      username = doc.paragraphs.first&.text&.strip || "unknown"

      # Construct the new file name
      new_filename = "#{original_name}_#{username}.docx"

      # Send the file with the new name
      send_file file_path, filename: new_filename, type: "application/vnd.openxmlformats-officedocument.wordprocessingml.document", disposition: "attachment"
    else
      redirect_to documents_path, alert: "File not found."
    end
  end

  private

  # Set document for show, destroy actions
  def set_document
    @document = Document.find(params[:id])
  end

  # Only allow a list of trusted parameters through
  def document_params
    params.require(:document).permit(:title, :file)
  end
end
