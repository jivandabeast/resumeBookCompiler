#!/bin/bash

function compilePDF() {
    if [[ $# -eq 0 ]]
        then echo ""
            echo "What files would you like to combine? (ex. Resumes/*.pdf)"
            read fileCard
    else
        fileCard=$1
    fi
    # $1 - file choice
    # echo ""
    
    # echo "What files would you like to combine? (ex. Resumes/*.pdf)"
    # read fileCard
    # echo "Compiling PDFs for $fileCard..."
    pdftk $fileCard cat output temp.pdf
    
    # echo "Compiling PDFs for $1..."
    # pdftk $1 cat output temp.pdf
    
    # echo "Exporting metadata file..."
    pdftk temp.pdf dump_data output meta.txt
    
    # echo "Done."
}

function metaDataBookmark() {
    if [[ $# -eq 0 ]]
        then echo ""
        echo "What is the name of the bookmark you would like to add?"
        read bookmarkName
        echo "What level should the bookmark be? (Usually 1 or 2)"
        read bookmarkLevel
        echo "What page is the bookmark on?"
        read bookmarkPage
    else
        bookmarkName=$1
        bookmarkLevel=$2
        bookmarkPage=$3
    fi

    # echo "What is the name of the bookmark you would like to add?"
    # read bookmarkName
    # echo "What level should the bookmark be? (Usually 1 or 2)"
    # read bookmarkLevel
    # echo "What page is the bookmark on?"
    # read bookmarkPage
    # echo ""
    # echo "Adding bookmark to metadata file..."
    echo "BookmarkBegin" >> meta.txt
    echo "BookmarkTitle: $bookmarkName" >> meta.txt
    echo "BookmarkLevel: $bookmarkLevel" >> meta.txt
    echo "BookmarkPageNumber: $bookmarkPage" >> meta.txt

    # echo "Adding bookmark to metadata file..."
    # echo "BookmarkBegin" >> meta.txt
    # echo "BookmarkTitle: $1" >> meta.txt
    # echo "BookmarkLevel: $2" >> meta.txt
    # echo "BookmarkPageNumber: $3" >> meta.txt

    # echo "Done."
}

# function updateMetaData() {
#     # $1 final file name/location
#     pdftk temp.pdf update_info meta.txt output "$1"
# }

function semiAutoRun() {
    if [[ $# -eq 0 ]]
        then echo ""
        echo "What files would you like to work with? (ex. Resumes/*.pdf)"
        read fileCard
        echo "What would you like this section to be named?"
        read sectionName
        echo "What would you like the finalized file to be named? (ex. 'Output/ResumeBook.pdf')"
        read finalName
    else
        fileCard=$1
        sectionName=$2
        finalName=$3
    fi

    compilePDF "$fileCard"

    finalPageCount=1
    for f in $fileCard; do
        echo ""
        pageCount=$(strings < "$f" | sed -n 's|.*/Count -\{0,1\}\([0-9]\{1,\}\).*|\1|p' | sort -rn | head -n 1)
        fileName=$(basename "$f" | cut -d "." -f 1)
        # let finalPageCount=$finalPageCount+$pageCount
        if [[ $fileName == "1-cover" ]]
            then metaDataBookmark "$sectionName" 1 $finalPageCount
        else
            metaDataBookmark "$fileName" 2 $finalPageCount
        fi
        let finalPageCount=$finalPageCount+$pageCount
    done

    # updateMetaData "$finalName"
    pdftk temp.pdf update_info meta.txt output "$finalName"

    echo "$finalName done."
}

function autoRun() {
    echo ""
    echo "Running graduate student compilation..."
    semiAutoRun "Resumes/*.graduate.pdf" "Graduate & Beyond" "Output/2-graduates.pdf"
    echo "Done."
    echo "Running senior student compilation..."
    semiAutoRun "Resumes/*.senior.pdf" "Seniors" "Output/3-seniors.pdf"
    echo "Done"
    echo "Running junior student compilation..."
    semiAutoRun "Resumes/*.junior.pdf" "Juniors" "Output/4-juniors.pdf"
    echo "Done"
    echo "Running sophomore student compilation..."
    semiAutoRun "Resumes/*.sophomore.pdf" "Sophomores" "Output/5-sophomores.pdf"
    echo "Done."
    # echo "Running freshman student compilation..."
    # semiAutoRun "Resumes/*.freshman.pdf" "Freshmen" "Output/6-freshmen.pdf"
    # echo "Done."

    echo "Beginning final compilation."
    compilePDF "Output/*.pdf"
    mv temp.pdf Output/ResumeBookFinal.pdf
    # pdftk $(Output/*.pdf) cat output "Output/ResumeBookFinal.pdf"
    # rm "Output/2-graduates.pdf" "Output/3-seniors.pdf" "Output/4-juniors.pdf" "Output/5-sophomores.pdf" "Output/6-freshmen.pdf"
    echo "Program complete."
}

function menu() {
    echo -ne "
PDF File Combiner
1) Combine files
2) Add Bookmarks
3) Run Semi-Automatic Compile
4) Run Automatic Compile
0) Exit
Choose an option: "
        read a
        case $a in
	        1) compilePDF ; menu ;;
	        2) metaDataBookmark ; menu ;;
            3) semiAutoRun ; menu ;;
            4) autoRun ; menu ;;
            0) exit 0 ;;
            *) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

menu