# Generate the hex-sticker logo + favicons for ggsegDKwm
# Run from the package root: Rscript data-raw/make_logo.R
#
# Requires: hexSticker, ggseg, ggplot2, ggseg.formats, pkgdown

library(hexSticker)
library(ggseg)
library(ggplot2)
library(ggsegDKwm)

dir.create("man/figures", recursive = TRUE, showWarnings = FALSE)

g15 <- dkwm() |>
  ggseg.formats::atlas_view_keep("axial_15") |>
  ggseg.formats::atlas_view_gather()
geom_tbl <- g15$data$geom          # 48 rows: label + geometry (each a coord tibble)

# expand each region's coordinate tibble, keeping its label
poly <- geom_tbl |>
  dplyr::mutate(.row = dplyr::row_number()) |>
  tidyr::unnest(geometry) |>
  # a unique polygon id per region + group + subgroup so holes/parts draw correctly
  dplyr::mutate(pid = interaction(.row, group, subgroup, drop = TRUE))

p15 <- ggplot(poly, aes(x = x, y = y, group = pid, fill = label)) +
  geom_polygon(colour = NA) +
  scale_fill_manual(values = wmparc_dk$palette, na.value = "grey") +
  coord_fixed() +                 # keep anatomical aspect ratio
  theme_void() +
  theme(legend.position = "none")

sticker(
  p15,
  package  = "ggsegDKwm",
  p_size   = 18, p_y = 0.6,p_color = "black",
  s_x = 1, s_y = 1.2, s_width = 1.4, s_height = 1.1,
  h_fill = "transparent", 
  h_color = "black",
  filename = "man/figures/logo.png"
)

# generate favicons for the pkgdown site from the logo
pkgdown::build_favicons(overwrite = TRUE)
