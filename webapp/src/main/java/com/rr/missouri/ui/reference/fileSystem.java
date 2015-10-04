package com.rr.missouri.ui.reference;


import java.io.File;
import java.io.IOException;


public class fileSystem {

    //Get the operating system
    String os = System.getProperty("os.name").toLowerCase();

    String dir = null;

    String macDirectoryPath = "/Applications/rapidRegistry/missouri/";
    String winDirectoryPath = "c:\\rapidRegistry\\missouri\\";
    String unixDirectoryPath = "/home/rapidRegistry/missouri/";

    public String getDir() {
        return dir;
    }
    
    public void setDir(String programName, String folderName) {
        
        if(programName.contains(" ")) {
            programName = programName.replaceAll(" ", "-").toLowerCase();
        }

        //Windows
        if (os.indexOf("win") >= 0) {
            this.dir = winDirectoryPath + programName + "\\" + folderName + "\\";
        } //Mac
        else if (os.indexOf("mac") >= 0) {
            this.dir = macDirectoryPath + programName + "/" + folderName + "/";
        } //Unix or Linux or Solarix
        else if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0 || os.indexOf("aix") >= 0 || os.indexOf("sunos") >= 0) {
            this.dir = unixDirectoryPath + programName + "/" + folderName + "/";
        }
    }
    
    public void setDirByName(String dirName) {
        //Windows
        if (os.indexOf("win") >= 0) {
            this.dir = winDirectoryPath + dirName;
        } //Mac
        else if (os.indexOf("mac") >= 0) {
            this.dir = macDirectoryPath + dirName;
        } //Unix or Linux or Solarix
        else if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0 || os.indexOf("aix") >= 0 || os.indexOf("sunos") >= 0) {
            this.dir = unixDirectoryPath + dirName;
        }
    }

    public static void delete(File file) throws IOException {

        if (file.isDirectory()) {

            //directory is empty, then delete it
            if (file.list().length == 0) {

                file.delete();

            } else {

                //list all the directory contents
                String files[] = file.list();

                for (String temp : files) {
                    //construct the file structure
                    File fileDelete = new File(file, temp);

                    //recursive delete
                    delete(fileDelete);
                }

                //check the directory again, if empty then delete it
                if (file.list().length == 0) {
                    file.delete();
                }
            }

        } else {
            //if file, then delete it
            file.delete();
        }
    }

    
    
    public boolean isWinMachine() {
    	
    	boolean winMachine = false;
        //Windows
        if (os.indexOf("win") >= 0) {
        	winMachine =  true;
        } 
        return winMachine;
    }
    
    public String setPath(String addOnPath) {
    	String path = "";
    	//Windows
        if (os.indexOf("win") >= 0) {
        	path = winDirectoryPath.replace("\\rapidRegistry\\", "") + addOnPath.replace("", "").replace("/", "\\");  
        } //Mac
        else if (os.indexOf("mac") >= 0) {
        	path = macDirectoryPath.replace("/rapidRegistry/", "") + addOnPath;
        } //Unix or Linux or Solarix
        else if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0 || os.indexOf("aix") >= 0 || os.indexOf("sunos") >= 0) {
        	path = unixDirectoryPath.replace("/rapidRegistry/", "") + addOnPath;        
        }
        return path;
    }

    
    public String setPathFromRoot(String addOnPath) {
    	
    	String path = "";
    	
    	//Windows
        if (os.indexOf("win") >= 0) {
        	path = addOnPath.replace("", "").replace("/", "\\");  
        } //Mac
        else if (os.indexOf("mac") >= 0) {
        	path = addOnPath;
        } //Unix or Linux or Solarix
        else if (os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0 || os.indexOf("aix") >= 0 || os.indexOf("sunos") >= 0) {
        	path = addOnPath;        
        }
        return path;
    }
    
      
}
