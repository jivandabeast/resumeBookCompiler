# Resume Book Compiler
## Designed for the UAlbany Cyber Jobs Fair
### Could also be adapted for other automated PDF compilation applications

## Requirements
The only requirement is the command line tool `pdftk`, which can be installed with the command `sudo snap install pdftk`.

## Running the script
The script has a few modes in which it could be run:

1. Combine Files

2. Add Bookmarks to Metadata File

3. Semi-Automatic

4. Full Automatic


## File Structure
The file structure is pretty simple, and matters most if you're planning on running the automated script mode. Obviously, resumes should go into the `Resumes/` folder. 

The files in that folder should follow this naming convention: `Last Name, First Name.classyear.pdf`

In practice, this should look like: `RamjiSingh, Jivan.senior.pdf`

When the script is finished running, the file will be placed into `Output/`. Be sure **not** to run the script with the output file already in the output directory, otherwise things will get a little funky (and not in a good way). 

## Dividers
I've already included dividers for the various class years, however if you want to change them just make sure to replace the files in the `Resumes/` directory with the same naming convention (`1-cover.classyear.pdf` i.e. `1-cover.sophomore.pdf`). Additionally, for the title page and table of contents, you can swap them out in the `Output/` directory, `1-title.pdf`. You may want to use the `meta.txt` file in there to update the new title document with pdf bookmarks, but that is optional. The command for that would be: `pdftk [new pdf] update_info meta.txt output 1-title.pdf`