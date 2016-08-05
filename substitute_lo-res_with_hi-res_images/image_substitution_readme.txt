How to build up image substitution pageseeder env

1. create project
2. create group

3.import configuration files for new media type(here is png) and new export interface.
go to project, click Dev->Project files, drop "ps-imagetest-2016.zip" in, then unpack and import. There will be two files "document-template.psml" and "editor-config.json" for media type, and one file "publish-config.xml" for providing pdf and docx exporting replacement interface

4. import documet sample and image sample
go to group,under document folder, click "upload" in the document menu.  Drop file "imagetest.zip" in, then unzip and import There will be one document with lo-res.png and hi-res.png image

5. import ps-publisher configuration files for function of exporting with image substitution.
go to project, click Dev->Toolbox->Project files to go to "Publish Engine Manager" (login as adminitrator)
drop file "pspublish-pstest-2016.zip" in uploading box, then unpack and import.
