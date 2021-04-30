###############################################################################
# 0 - Intro to RStudio
###############################################################################
# Contents:
# 0.1 - Navigating the RStudio IDE
# 0.2 - Introduction to R Projects
# 0.3 - Importing a project from a GitHub repo
# 0.4 - Installing and loading packages
# 0.5 - Keyboard shortcuts
# 0.6 - Importing data
# 0.7 - Viewing data
#	0.8 - Exporting data
# 0.9 - Random starter bonus info


#==============================================================================
# 0.1 - Navigating the RStudio IDE
#==============================================================================



#==============================================================================
# 0.2 - Introduction to R Projects
#==============================================================================
# RStudio projects make it straightforward to divide your work into multiple 
# contexts, each with their own working directory, workspace, history, and 
# source documents. 

# This also helps when you want to share your code with others as projects are 
# self referential from a working directory perspective meaning that your 
# collaborators won't have to go in and change all of their file paths in order 
# to get the code to work.


#------------------------------------------------------------------------------
# To create a new project: 
#------------------------------------------------------------------------------
# From the toolbar at the top of the RStudio IDE:
# 1. File -> New Project -> New Directory -> New Project
# 2. Then just give your project a name and the local directory to save it to


#------------------------------------------------------------------------------
# To open an existing project:
#------------------------------------------------------------------------------
# Double click the project file (ends in .Rproj) icon (blue cube with an R)


#------------------------------------------------------------------------------
# More information on R projects can be found here: 
#------------------------------------------------------------------------------
# https://support.rstudio.com/hc/en-us/articles/200526207-Using-Projects



#==============================================================================
# 0.3 - Importing a project from a GitHub repo
#==============================================================================
# Importing a project from an existing GitHub repository is very similar to 
# the process for creating a new project.

# To clone an existing project from GitHub: 
#-------------------------------------------
# From the toolbar at the top of the RStudio IDE:
# 1. File -> Version Control -> Git
# 2. Then copy and paste the address from the repo 
#    (ex. "https://github.com/plear/kRtraining") into the Repository URL field
# 3. Specify the directory where you'd like to save your local copy. (NOTE: you
#    may want to place it in your local user folder an not in a OneDrive destination)
# 4. Click Create



#==============================================================================
# 0.4 - Installing and Loading packages
#==============================================================================

#------------------------------------------------------------------------------
# Installing Packages
#------------------------------------------------------------------------------
# You can install a package from CRAN (Comprehensive R Archive Network) 
# by passing its name in the install.packages() function.

install.packages("readxl") # For reading Excel files
install.packages("writexl") # For writing Excel files
install.packages("haven") # For reading/writing, SAS, SPSS, and Stat files 
install.packages("tidyverse") # A collection of packages that covers many of the 
                              # activites you're likely to perform in R
install.packages("janitor") # Handy quality of life cleaning functions

#------------------------------------------------------------------------------
# Loading Packages
#------------------------------------------------------------------------------
# Once you have installed a package you can load it using the library() function:
library(readxl)
library(writexl)
library(haven)
library(tidyverse)

# Note: You only need to install packages once but you have to load the packages
# you want to use every time you start a new session



#==============================================================================
# 0.5 - Keyboard Shortcuts
#==============================================================================
# There are many keyboard shortcuts available in RStudio but you only need to 
# remember one of them:

# Alt + Shift + K (ASK)

# This opens a reference containing all of the available keyboard shortcuts.


# Other frequently used shortcuts worth committing to memory:
#-------------------------------------------------------------
# Ctrl + Enter: runs the code chunk you have selected
# Ctrl + Shift + C: comments/uncomments selected code

# You can look up the documentation for any package/function you have installed
# by running: help("name") or ?name
# ex. help("read_xlsx"), ?readxl, etc.



#==============================================================================
# 0.6 - Importing data
#==============================================================================
# The GUI approach:
#------------------------------------------------------------------------------
# you can import data files using the GUI by clicking on the "Import Dataset"
# button at the top of the "Environment" tab and selecting the desired data type
# and file. This also generates a preview of the data as it will be imported 
# and displays the code that will be executed behind the scenes to load your data.

#------------------------------------------------------------------------------
# The programmatic approaches:
#------------------------------------------------------------------------------
# The shortcoming of the GUI approach is the manual effort involved and the 
# inability to automate that action in the context of a bigger script. In most
# it's preferable to directly encode your data imports:


#------------------------------------------------------------------------------
# Excel example
#------------------------------------------------------------------------------
# First let's take a look at the documentation on the read_xlsx function from
# the readxl package we installed earlier:
?read_xlsx

# The function documentation specifies that we'll need to pass the file path to
# the file we want to import and also provides a list of other optional
# arguments we could pass (all of the arguments ending with "= NULL" are going to
# be optional)

# For now, let's just run the function with the required path command
excel_ex <- read_xlsx(path = "data/GeoIDs - State.xlsx")


#------------------------------------------------------------------------------
# CSV example
#------------------------------------------------------------------------------
# The tidyverse packages we installed and loaded earlier includes a package
# called "readr" which includes a function called "read_csv". 
?readr

# Similar to the read_xlsx function, read_csv's only required argument is the
# location of the CSV file you want to load. Let's try reading one in now:
csv_ex <- read_csv(file = "data/GeoIDs - State.csv")


#------------------------------------------------------------------------------
# Miscellaneous notes:
#------------------------------------------------------------------------------
# There are similar functions for importing SAS and SPSS data available in 
# the "haven" package. In addition, if you ever find yourself trying to load
# large, slow-loading CSV files I would highly recommend looking into the "fread" 
# function in the "data.table" package.



#==============================================================================
# 0.7 - Viewing data (console line and gui) 
#==============================================================================
# Once you have some data loaded in your environment there are a number of ways
# to explore it:

#------------------------------------------------------------------------------
# GUI
#------------------------------------------------------------------------------
# The environment tab (located in the upper right pane by default) displays all
# of the objects you have loaded in your session. 

# If the object is a data frame you'll notice an arrow in a blue circle next to 
# the object's name. Clicking on icon will display a list of the columns, their 
# field types, and a preview of the leading values.

# Clicking on the object name will open it in a preview tab and allow you to
# view it as though it were a spreadsheet.


#------------------------------------------------------------------------------
# Programmatic exploration
#----------------------------------
# There are a range of functions intended to help explore the nature of your data

# class() will return the class of your object
class(excel_ex)

# names() prints the colnames of a given dataset
names(excel_ex)

# str() will return the structure of your object
str(excel_ex)

# glimpse() from tidyverse provides a high level summary of the data
glimpse(excel_ex)

# summary() provides a similar view to glimpse and str
summary(excel_ex)

# you can reference columns within a data frame using the '$' symbol
excel_ex$statename

# if you have a character field and you want to see the frequency of unique
# values you can use the summary() function in combination with the as.factor()
# function (in R a factor = a categorical variable):
summary(as.factor(excel_ex$statename))



#==============================================================================
#	0.8 - Exporting data
#==============================================================================
# The process for writing data out is usually similar to reading it in. Let's
# take a look at the documentation for writing a CSV using the write_csv function
# from the readr package (part of the tidyverse):

?write_csv

# You can see from the documentation that there are two required arguments (those
# that don't have " = ____" after them). The first is "x" which is the name of
# the object you want to write out and the second is "file" which is the 
# destination/file name you want to write to. Let's try to write the csv_ex data
# out to its original location with a new name:

write_csv(csv_ex, file = "data/CSV_example.csv")


# If you navigate to the "data" folder in the project you should now see your
# newly created CSV file

# You can also write your data out as a number of other file types. Let's take a
# look at the documentation for the "write_xlsx" function from the writexl package:

?write_xlsx

# Similar to the write_csv function, you'll notice that there are two required
# arguments: x (the object name you want to write out) and path (the destination)

write_xlsx(csv_ex, path = "data/XL_example.xlsx")
# Notice how we used the csv_ex object but wrote out an XL file? Once the Excel 
# data was read into our R session it ceased to be Excel data and was converted
# into an R data frame. Our csv_ex and excel_ex objects have been functionally
# identical all along. 



#==============================================================================
# 0.9 - Additional Resources
#==============================================================================

# A growing collection of internal R examples are being assembled at: 
#-------------------------------------------------------------------------
# https://rstudioconnect.analytics.kellogg.com/RStudio_Knowledge_Library/

# Note: you must be logged into the K network/VPN to access the content

# Some of this content is specific to our RStudio Server environment but many of
# the examples will also be applicable for desktop users, especially if you
# intend to connect to and query data from internal resources such as SQL Server.

