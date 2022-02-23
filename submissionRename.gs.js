function renameResume() {
  // Adapted from https://medium.com/@yashashreepatel/how-to-rename-google-forms-responses-in-the-google-drive-automatically-94f033d90b24

  // Take the ID from the link to the form (https://docs.google.com/forms/d/[ID]/edit)
  var form = FormApp.openById('[ID HERE]');
  var formResponses = form.getResponses();
  var baseString = 'https://drive.google.com/file/d/';
  var endString = '/view?usp=drivesdk';

  // Take the ID from the link to the submissions folder in drive (https://drive.google.com/drive/u/0/folders/[ID])
  var folder = DriveApp.getFolderById('[ID HERE]');
  var files = folder.getFiles();
  
  while (files.hasNext()) {
    var file = files.next();
    for (var i = 0; i < formResponses.length; i++) {
      var formResponse = formResponses[i];
      var itemResponses = formResponse.getItemResponses();

      // Item numbering may be subject to change if you alter the form with more questions/different ordering
      // Item 0 - Name (First, Last)
      var itemResponseName = itemResponses[0];
      // Item 1 - Class Year
      var itemResponseYear = itemResponses[1];
      // Last Item - File Submission
      var itemResponseFile = itemResponses[itemResponses.length - 1];
      
      var fileID = itemResponseFile.getResponse();
      var newName = itemResponseName.getResponse() + "." + itemResponseYear.getResponse();
      Logger.log(newName)
      var url = baseString + fileID + endString;
      var urlCheck = file.getUrl();
      if ( url == urlCheck) {
        var modName = newName + ".pdf";
        file.setName(modName);
      }
    }
  }
}