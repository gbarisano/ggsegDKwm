# Create the ggsegDKwm atlas
#
# Recreates the axial Desikan-Killiany white-matter parcellation + basal-
# ganglia atlas from a FreeSurfer wmparc segmentation using the ggseg.extra
# volumetric pipeline.
#
# Requirements:
#   - FreeSurfer installed (subcortical pipeline + mri_* tools)
#   - ggseg.extra, ggseg.formats, usethis
#
# NOTE: ggseg.extra's tessellate_label() must be patched to binarize each
# label before mri_pretess/mri_tessellate; otherwise wmparc labels tessellate
# to zero vertices. See patch below and upstream issue.
#
# Run with: Rscript data-raw/make_atlas.R

library(ggseg.extra)
library(ggseg.formats)

# ---- paths (edit for your machine) ------------------------------------------
Sys.setenv(FREESURFER_HOME = "/path/to/freesurfer")
Sys.setenv(SUBJECTS_DIR    = "/path/to/subjects")

vol  <- file.path(Sys.getenv("SUBJECTS_DIR"),
                  "fsaverage_sym", "mri", "wmparc_wmonly_ras.mgz")
lut  <- file.path(Sys.getenv("SUBJECTS_DIR"), "wmonly_LUT.txt")
norm <- file.path(dirname(vol), "brain.mgz")

# ---- patch tessellate_label (binarize before pretess/tessellate) ------------
NORM_REF <- norm
patched_tessellate_label <- function(volume_file, label_id, output_dir,
                                     verbose = ggseg.extra:::get_verbose(),
                                     skip_existing = ggseg.extra:::get_skip_existing()) {
  ggseg.extra:::check_fs(abort = TRUE)
  label_str    <- sprintf("%04d", label_id)
  base_name    <- file.path(output_dir, label_str)
  bin_file     <- paste0(base_name, "_bin.mgz")
  pretess_file <- paste0(base_name, "_pretess.mgz")
  tess_file    <- paste0(base_name, "_tess")
  smooth_file  <- paste0(base_name, "_smooth")
  if (skip_existing && file.exists(smooth_file))
    return(ggseg.extra:::read_fs_surface(smooth_file, verbose = verbose))
  volume_file <- ggseg.extra:::ensure_fs_compatible_nifti(volume_file, output_dir)
  ggseg.extra:::run_cmd(sprintf("mri_binarize --i %s --match %d --o %s",
                                shQuote(volume_file), label_id, shQuote(bin_file)), verbose = verbose)
  ggseg.extra:::run_cmd(sprintf("mri_pretess %s 1 %s %s",
                                shQuote(bin_file), shQuote(NORM_REF), shQuote(pretess_file)), verbose = verbose)
  ggseg.extra:::run_cmd(sprintf("mri_tessellate %s 1 %s",
                                shQuote(pretess_file), shQuote(tess_file)), verbose = verbose)
  ggseg.extra:::run_cmd(sprintf("mris_smooth -nw %s %s",
                                shQuote(tess_file), shQuote(smooth_file)), verbose = verbose)
  ggseg.extra:::read_fs_surface(smooth_file, verbose = verbose)
}
environment(patched_tessellate_label) <- asNamespace("ggseg.extra")
assignInNamespace("tessellate_label", patched_tessellate_label, ns = "ggseg.extra")

# ---- axial views (RAS space) ------------------------------------------------
starts <- seq(55, 175, by = 5)
axial_all <- data.frame(
  name  = sprintf("axial_%02d", seq_along(starts)),
  type  = "axial",
  start = starts,
  end   = starts + 4,
  stringsAsFactors = FALSE
)

# ---- build ------------------------------------------------------------------
atlas_full <- create_subcortical_from_volume(
  input_volume  = vol, input_lut = lut,
  atlas_name    = "dkwm",
  output_dir    = "data-raw/dkwm",
  dilate = 1, views = axial_all, skip_existing = TRUE, verbose = TRUE
)

# ---- keep only the good views -----------------------------------------------
good_views <- c("axial_09","axial_11","axial_13","axial_15",
                "axial_18","axial_21","axial_24")
atlas_trim <- atlas_full |>
  ggseg.formats::atlas_view_keep(paste(good_views, collapse = "|")) |>
  ggseg.formats::atlas_view_gather()

# ---- store as internal data (dot-prefixed), matching ggsegSchaefer ----------
.dkwm <- atlas_trim
usethis::use_data(.dkwm, internal = TRUE, overwrite = TRUE)
# If required for sf-free installs, run once on a machine with sf:
# ggseg.formats::migrate_atlas_files("R")
