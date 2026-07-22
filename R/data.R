#' Desikan-Killiany White-Matter Parcellation Atlas (axial)
#'
#' Brain atlas containing the Desikan-Killiany white-matter parcellation
#' ('wmparc', cortical labels projected into the white matter) together with
#' the basal-ganglia structures (caudate, putamen, pallidum, thalamus), in
#' symmetric 'fsaverage_sym' template space. Cortical grey matter is merged
#' into a single background label. Provides 2D polygon geometry with axial
#' slice views for use with [ggseg::geom_brain()].
#'
#' @family ggseg_atlases
#' @family subcortical_atlases
#'
#' @references
#'   Desikan RS, et al. (2006). An automated labeling system for subdividing
#'   the human cerebral cortex on MRI scans into gyral based regions of
#'   interest. *NeuroImage*, 31(3):968-980.
#'   \doi{10.1016/j.neuroimage.2006.01.021}
#'
#' @return A [ggseg.formats::ggseg_atlas] object (subcortical).
#' @export
#' @examples
#' dkwm()
#' \dontrun{plot(dkwm())}
dkwm <- function() .dkwm
