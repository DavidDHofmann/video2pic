################################################################################
#### Load Dependencies
################################################################################
#' @importFrom reticulate source_python
#' @importFrom reticulate py_install conda_create use_condaenv
NULL

#' Install python dependencies for video2pic
#'
#' Function to install all python dependencies for video2pic to work
#' @export
#' @param py_env the conda environment to use. "video2pic" by default
#' @examples
#' video2pic(py_env = "video2pic")
video2pic_install <- function(py_env = "video2pic") {
  reticulate::conda_create(py_env, python_version = 3.7)
  reticulate::use_condaenv(py_env)
  reticulate::py_install("opencv-python", envname = py_env, pip = T)
}

#' Initalize the python environment
#'
#' Function to initalize the python environment
#' @export
#' @param py_env the conda environment to use. "video2pic" by default
#' @examples
#' video2pic(py_env = "video2pic")
video2pic_initialize <- function(py_env = "video2pic") {
  reticulate::use_condaenv(py_env)
}

#' Convert video to jpeg
#'
#' Function to convert a video into frames
#' @export
#' @param filepath filepath(s) to the video file(s) that need to be converted
#' @param outdir character vector, either of length 1 or same length as
#' \code{file} directory or directories to the folder(s) where the converted
#' file(s) should be stored. By default, this is set to the directory of the
#' input file(s).
#' @param fps numeric frames per second that should be stored
#' @param overwrite logical should frames that already exist in the output
#' directory be overwritten?
#' @examples
#' Coming
video2pic <- function(file = NULL, outdir = NULL, fps = NULL, overwrite = F) {

  # If no file is provided, stop
  if (is.null(file)){
    stop("Please provide at least one file")
  }

  # Check if all files exist
  exist <- file.exists(file)
  if (!all(exist)){
    stop("Some of the specified files do not exist")
  }

  # If no output directory is provided, set it to the directory of the input
  # file
  if (is.null(outdir)){
    outdir <- dirname(file)
  } else {
    if (!all(dir.exists(outdir))){
      stop("specificied output directory does not exist")
    }
  }

  # Make sure a correct number of directories is provided
  if (length(outdir) != length(file) & length(outdir) != 1){
    stop("outdir has to be of length 1 or same length as file")
  }

  # If a signle output directory is provided, repead it for all files
  if (length(outdir) == 1){
    outdir <- rep(outdir, length(file))
  }

  # If no fps is desired, stop
  if (is.null(fps)){
    stop("Please provide a valid fps")
  }

  # Source the python script
  pypath <- system.file("python", "video2pic.py", package = "video2pic")
  source_python(pypath)

  # Prepare progress bar
  cat("Extracting frames...\n")
  pb <- txtProgressBar(
      min     = 0
    , max     = length(file)
    , initial = 0
    , style   = 3
    , width   = 55
  )

  # Loop through each file and extract the frames
  for (i in 1:length(file)) {

    # Check if output files alraedy exist
    base <- strsplit(basename(file[i]), split="\\.")[[1]][-2]
    base <- paste0(base, "_Frame_0.JPG")
    outname <- file.path(outdir[i], base)

    # If output already exists, skip
    if (file.exists(outname) & !overwrite) {

      warning("Frames for ", basename(file)," already exist in the output directory... Skipping\n")
      next

      # Otherwise, run extraction
    } else {

      # Run the function
      video2pic_py(file[i], outdir[i], fps)

    }
    # Print progress bar update
    setTxtProgressBar(pb, i)
  }
  cat("\nExtracting done...\n")
}
