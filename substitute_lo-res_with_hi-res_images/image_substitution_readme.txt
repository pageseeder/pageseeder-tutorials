How to build up image substitution pageseeder env

1. create project
2. create group
3. create image type through uploading files 
go to project, then click Dev->Project files
under Template-><project>, 
create folder "document"->"png", upload "document-template.psml"and "editor-config.json"
Then user can go to Dev->Document config to check if new media type is ready.
4. set up publish config file for exportin PDF and DocX format with image replacement
go to project, then click Dev->Project files
under Template-><project>, 
create folder "Publish", upload "publish-config.xml";

5. import documet smaple and image sample
go to this group,under document folder, click "upload" in the document menu.  Drop file "imagetest.zip" in, then unzip and import There will be one document with lo-res.png and hi-res.png
6. import ps-publisher configuration files for function of exporting with image substitution.
go to project, click Dev->Toolbox->Project files to go to "Publish Engine Manager" (login as adminitrator)
drop file "pspublish-pstest-2016.zip" in uploading box, then unpack and import.

Note: Step3 and Step4 can be replaced with packed files importing if the exported project file can be recognized by drop box.