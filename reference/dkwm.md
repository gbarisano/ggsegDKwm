# Desikan-Killiany White-Matter Parcellation Atlas (axial)

Brain atlas containing the Desikan-Killiany white-matter parcellation
('wmparc', cortical labels projected into the white matter) together
with the basal-ganglia structures (caudate, putamen, pallidum,
thalamus), in symmetric 'fsaverage_sym' template space. Cortical grey
matter is merged into a single background label. Provides 2D polygon
geometry with axial slice views for use with
[`ggseg::geom_brain()`](https://ggsegverse.github.io/ggseg/reference/ggbrain.html).

## Usage

``` r
dkwm()
```

## Value

A
[ggseg.formats::ggseg_atlas](https://ggsegverse.github.io/ggseg.formats/reference/ggseg_atlas.html)
object (subcortical).

## References

Desikan RS, et al. (2006). An automated labeling system for subdividing
the human cerebral cortex on MRI scans into gyral based regions of
interest. *NeuroImage*, 31(3):968-980.
[doi:10.1016/j.neuroimage.2006.01.021](https://doi.org/10.1016/j.neuroimage.2006.01.021)

## Examples

``` r
dkwm()
#> 
#> ── Desikan-Killiany white matter parcellation ggseg atlas ──────────────────────
#> Type: subcortical
#> Regions: 40
#> Hemispheres: left, right
#> Views: axial_09, axial_11, axial_13, axial_15, axial_18, axial_21, axial_24
#> Palette: ✔
#> Rendering: ✔ ggseg
#> ✔ ggseg3d (meshes)
#> ────────────────────────────────────────────────────────────────────────────────
#>     hemi            region                  label
#> 1   left cerebral exterior Left-Cerebral-Exterior
#> 2   left          thalamus          Left-Thalamus
#> 3   left           caudate           Left-Caudate
#> 4   left           putamen           Left-Putamen
#> 5   left          pallidum          Left-Pallidum
#> 6  right          thalamus         Right-Thalamus
#> 7  right           caudate          Right-Caudate
#> 8  right           putamen          Right-Putamen
#> 9  right          pallidum         Right-Pallidum
#> 10  left          bankssts         wm-lh-bankssts
#> ... with 69 more rows
if (FALSE) plot(dkwm()) # \dontrun{}
```
