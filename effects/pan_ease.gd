class_name PanEase

# Thanks so much to Smash Highlights on Discord for generating this LUT!
# I gave it a good few tries, but the results kept being weird...
# This one looks like it fits footage from the game perfectly, though!
static var PAN_LUT = [
    [0.0, 0.0],
    [0.06666666666666667, 0.01546750087],
    [0.13333333333333333, 0.03049086626],
    [0.2, 0.04597767736],
    [0.26666666666666666, 0.1001428958],
    [0.3333333333333333, 0.1920789403],
    [0.4, 0.2840149847],
    [0.4666666666666667, 0.3841578805],
    [0.5333333333333333, 0.4843007763],
    [0.6, 0.5839802263],
    [0.6666666666666666, 0.6841231221],
    [0.7333333333333333, 0.7842467076],
    [0.8, 0.8766461978],
    [0.8666666666666667, 0.9686015525],
    [0.9333333333333333, 0.9840690534],
    [1.0, 1.0],
]


static func courtroom_pan_lut_ease(t: float) -> float:
    var v = 0
    if t < 0:
        return 0
    elif t >= 1:
        return 1
    else:
        for i in PAN_LUT.size() - 1:
            if PAN_LUT[i][0] <= t and t <= PAN_LUT[i + 1][0]:
                var a = PAN_LUT[i][1]
                var b = PAN_LUT[i + 1][1]
                v = remap(t, PAN_LUT[i][0], PAN_LUT[i + 1][0], a, b)
    return v