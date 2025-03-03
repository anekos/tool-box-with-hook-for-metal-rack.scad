$fn = 70;

// Variables {{{

width = 250;
height = 50;
depth = 90;
r = 5;

thickness = 2;

hook_inner_size = 6;
hook_thickness = 8;
hook_nail_length = 40;
hook_width = 20;
hook_inner_r = 2;
hook_distance = 130;

cells = 6;

// }}}

// Utils {{{

module fillet2d(r, d = 0)
{
    offset(r = r - d) offset(delta = -r) children(0);
}

// }}}

// Core {{{

module box()
{
    difference()
    {

        linear_extrude(height = depth)
        {
            fillet2d(r = 5, d = 0)
            {
                square([ width, height ], center = true);
            }
        }

        translate([ 0, 0, thickness ])
        {
            linear_extrude(height = depth)
            {
                fillet2d(r = 5, d = thickness)
                {
                    square([ width - thickness * 2, height - thickness * 2 ], center = true);
                }
            }
        }
    }
}

module hook()
{
    r = hook_inner_r;

    translate([ 0, height / 2, depth - hook_nail_length - hook_thickness ])
    {
        rotate([ 0, -90, 0 ])
        {
            linear_extrude(height = hook_width, center = true)
            {
                translate([ hook_nail_length - r, hook_inner_size - r ])
                {
                    polygon([
                        [ r, r ],
                        [ r, 0 ],
                        [ 0, r ],
                    ]);
                }

                translate([ hook_nail_length - r, 0 ])
                {
                    polygon([
                        [ r, r ],
                        [ r, 0 ],
                        [ 0, 0 ],
                    ]);
                }

                translate([ hook_nail_length, 0 ])
                {
                    square([ hook_thickness, hook_inner_size + hook_thickness ]);
                }

                translate([ 0, hook_inner_size ])
                {
                    square([ hook_nail_length, hook_thickness ]);
                }
            }
        }
    }
}

module hooks()
{
    translate([ hook_distance / 2 + hook_width / 2, 0, 0 ])
    {
        hook();
    }

    translate([ -(hook_distance / 2 + hook_width / 2), 0, 0 ])
    {
        hook();
    }
}

module separator()
{
    linear_extrude(height = depth)
    {
        square([ thickness, height ], center = true);
    }
}

module separators()
{
    translate([ -width / 2, 0, 0 ])
    {
        for (i = [1:cells - 1])
        {
            translate([ i * width / cells, 0, 0 ])
            {
                separator();
            }
        }
    }
}

// }}}

box();
hooks();
separators();
