function ai_smooth_rotation(arg0)
{
    var ad = angle_difference(direction, most_desired_movement_dir);
    direction -= (min(abs(ad), arg0) * sign(ad));
}
