# Tag Documentation

## Tags

### General control

```xml
<play />
```

Starts the current queued text and commands.

Once this tag is reached, the text will clear, so it's best to put a `<wait>` tag immediately before it so the viewer has time to read the text.

```xml
<wait duration="float" />
```

Pauses movement through the script for `duration` seconds.

```xml
<set_text_speed value="float:1.0" />
```

Sets the speed for the text display to `value`.
The default is `1.0`.

### Name tag and text box

```xml
<nametag.set_text text="string" />
```

Sets the nametag to display the given string `text`. If `text` is not present or is an empty string, then the nametag will be hidden.

```xml
<box.set_visible value="bool:true" />
```

Sets the visibility of the text box.

```xml
<box.animate_in />
```

Moves the text box on-screen from below.

```xml
<box.animate_out />
```

Moves the text box down past the bottom of the screen.

```xml
<arrow.set_visible value="bool:true" />
```

Sets the visibility of the "next dialogue" arrow in the corner of the text box.

### Text color

```xml
<color value="string"></color>
```

Sets the color of the enclosed text to `value`.

### Visual effects

```xml
<flash duration="float:0.15" />
```

Turns the screen white for `duration` seconds.

```xml
<shake magnitude="float:5.0" duration="float:0.3" />
```

Shakes the screen with a given `magnitude` for `duration` seconds.

```xml
<confetti.start count="float:31" />
```

Starts playing the confetti animation, with `count` flakes of confetti.

```xml
<confetti.stop />
```

Stops the confetti animation and immediately deletes all on-screen confetti.

```xml
<action_lines.set_direction value="left|right" />
```

Sets the background action lines from the `zoom` camera position to move either `left` or `right`.

### Sprites

```xml
<sprite.set pos="string" res="path" anim="string" />
```

Changes the animated sprite for the given `pos`, to use the animation named `anim` within the `SpriteFrames` asset at the path `res`.

The current built-in locations are:

- `left` - The left side of the courtroom, where the defense attorney stands.
- `center` - The witness stand.
- `right` - The right side of the courtroom, where the prosecutor stands.
- `judge` - The view looking up at the Judge.
- `counsel` - The view of a character standing next to the defense attorney.
- `zoom` - The view of a character with blue "power lines" moving behind them.

### Music and sound effects

> [!WARNING]
> Loading WAV audio files from outside of Objection-Godot is currently broken.
> Until it gets fixed, it's best to use MP3 or OGG files instead.

```xml
<music.play res="path" />
```

Plays the music file given by `res`.
If `res` is not specified or is an empty string, then the last loaded music will be played.

```xml
<music.stop />
```

Stops the currently-playing music.

```xml
<sound.play res="path" />
```

Plays the sound effect at the path given by `res` once.

```xml
<blip.set type="male|female|typewriter|none" />
```

Sets the speaking blip sound effect to `type`.

- `type="male"` and `type="female"` are used for male and female characters, respectively.

- `type="typewriter"` is used for scene introductions, such as at the start of a trial or investigation segment.

- `type="none"` disables the sounds completely.

### Camera

```xml
<camera.cut to="location" />
```

Immediately snaps the camera to the location given by `to`.

```xml
<camera.pan to="location" />
```

Moves the camera to the location given by `to` over a short period of time.

This is intended to be used when the initial and final positions of the camera are within the courtroom "wide shot" (that is, they are both `left`, `center`, or `right`).

### "Witness Testimony" title text

```xml
<big_title.play top="string" bottom="string" color="string" dir="lr|ud" />
```

Displays a "Witness Testimony" animation in large block letters.
The text is always made of two lines.
The string for `top` is displayed as the top line, and the string for `bottom` is displayed as the bottom line.
The fill color of the text is defined by `color`.

The `dir` argument dictates how the two lines of text should animate out.

- If `dir="lr"`, the top line will move right, and the bottom line will move left.

- If `dir="ud"`, the top line will move up, and the bottom line will move down.

### Evidence

```xml
<evidence.show side="left|right:right" res="path:" />
```

Plays an animation of evidence appearing on the side specified by `side`, either `left` or `right`.
The texture at the path specified by `res` is shown in the evidence box.

```xml
<evidence.hide side="left|right:right" />
```

Plays an animation of evidence on the side specified by `side`, either `left` or `right`, disappearing.

```xml
<evidence.hide_immediate side="left|right:right" />
```

Immediately hides the evidence on the side specified by `side`, either `left` or `right`, without any animation.

### New evidence

```xml
<new_evidence.animate_in title="string:" description="string:" res="string:" />
```

Animates the "new evidence" box on-screen, sliding in from the right.
The provided `title` and `description` text are displayed on the box.
A path to an image to display as the evidence thumbnail can be provided with `res`.

```xml
<new_evidence.animate_out />
```

Animates the "new evidence" box off-screen, sliding off to the left.

### Exclamation bubbles

```xml
<bubble.animate type="objection|holdit|takethat" />
```

Animates an exclamation bubble given by `type`.

Note that no sound is played automatically.
To play a character's voice clip along with the bubble, use a `<sound>` tag at the same time.

### Gavel slam

```xml
<gavel.animate num="int:3" between="float:0.17" after="float:0.766" />
```

Animates the Judge's gavel slam `num` times in a row.

The argument `between` gives the delay between slams, if more than one slam is performed.

The argument `after` gives the delay after the last slam before script execution continues.

### Wide shot

> [!NOTE]
> This refers to the view of the courtroom where the lawyers, witness, judge, and gallery are all visible at once.

```xml
<wide.set_sprite pos="prosecution|defense|witness|judge" res="location" />
```

Sets the character at `pos` in the wide shot to use the texture at `res`.

```xml
<wide.gallery.set_visible value="bool" />
```

Sets the visibility of the people in the gallery.

```xml
<wide.gallery.set_animated value="bool" />
```

Sets whether or not the people in the gallery move back and forth.

### Verdict

```xml
<verdict.animate text="string" group_by="word|letter:letter" font_color="color:white" font_outline_color="color:black" />
```

Displays the provided `text` on-screen as if it were the Judge's verdict, with a dramatic animation and sound effects.

If `group_by="word"`, then each word in the `text` (i.e., groups of non-space characters) will animate together.
If `group_by="letter"`, each letter/character in the `text` will animate in sequence.

The `font_color` and `font_outline_color` arguments set the color of the text and its outline, respectively.

### Flashing segment label

```xml
<segment_title.set text="string:" font_color="color:white" font_outline_color="color:aa-flashtestimony" time_in="float:1.433" time_out="float:0.34" />
```

Displays a flashing label in the top-left corner of the screen with the provided `text`.
The label's font has the body color given by `font_color` and the outline color given by `font_outline_color`.
It will appear for `time_in` seconds, and then disappear for `time_out` seconds.

If no `text` is provided (or `text` is an empty string) then the title will be invisible.

Defaults for the other arguments replicate the look and timing of the "Testimony" flashing label in the *Ace Attorney* DS games.

### Static color background

```xml
<bg.set_visible value="bool:true" />
```

Sets whether or not the solid-color background is visible.

```xml
<bg.set_color value="color" />
```

Sets the color of the background.

```xml
<bg.animate_in duration="float:0.5" />
```

Fades in the solid-color background over `duration` seconds.

```xml
<bg.animate_out duration="float:0.5" />
```

Fades out the solid-color background over `duration` seconds.

### "Perceive" background from *Apollo Justice*

```xml
<perceive.set_visible value="bool:true" />
```

Sets whether or not the "Perceive" background is visible.

```xml
<perceive.animate_in duration="float:0.5" />
```

Fades in the "Perceive" background over `duration` seconds.

```xml
<perceive.animate_out duration="float:0.5" />
```

Fades out the "Perceive" background over `duration` seconds.

### Mood Matrix from *Dual Destinies*

#### Background

```xml
<mood_matrix.bg.set_visible value="bool:true" />
```

Sets whether or not the Mood Matrix background is visible.

```xml
<mood_matrix.bg.animate_in duration="float:0.5" />
```

Fades in the Mood Matrix background over `duration` seconds.

```xml
<mood_matrix.bg.animate_out duration="float:0.5" />
```

Fades out the Mood Matrix background over `duration` seconds.

```xml
<mood_matrix.bg.set_time_scale value="float:1.0" />
```

Sets the time scale for the Mood Matrix background animation.

A value of `1.0` is good for standard Mood Matrix segments, and a value of around `6.0` works well for overload segments.

#### Foreground UI

```xml
<mood_matrix.bootup.animate_in />
```

Plays the "bootup" animation for a Mood Matrix segment, the first half of the introduction.
The screen is tinted blue, and a "loading" indicator appears and fills up.
Once it is full, the logo appears and animates out, quickly fading the screen to white.

```xml
<mood_matrix.ui.animate_in play_sound="bool:true" />
```

Plays the second half of the normal introduction animation, where the logo continues animating and the emotion markers appear.
This clears the white overlay that the "bootup" animation sets.
Place any commands you'd like to execute behind the white flash after the "bootup" command and before this command.

```xml
<mood_matrix.ui.animate_in_overload emotions="happy,sad,angry,surprised" />
```

Plays the "emotional overload" animation.
The active emotions are listed, separated by commas, in the `emotions` argument.

```xml
<mood_matrix.ui.set_visible value="bool:true" />
```

Sets the UI with the emotion markers to be visible or invisible, with no animation.

```xml
<mood_matrix.ui.set_ring_noise value="bool:true" />
```

Sets whether or not the white ring in the Mood Matrix UI should have noise on its edges, as it appears in an "emotional overload" segment.

```xml
<mood_matrix.ui.set_emotion_level type="happy|sad|angry|surprised" intensity="float:1.0" overload="bool:false" />
```

Sets the intensity of the emotion marker specified by `type`.
Normally, `intensity` controls the size of the ripples emanating from the emotion marker.
If `overload` is `true`, the marker will display the large ripples from the "emotional overload" segments, and `intensity` is ignored.

```xml
<mood_matrix.ui.set_overload_tints emotions="happy,sad,angry,surprised" />
```

Sets cycling tints over the screen corresponding to the colors for the given `emotions`.
To stop this effect, use this command with an empty string for `emotions`.

#### Noise Level

```xml
<mood_matrix.noise.animate from="int" to="int" sound_code="" />
```

Performs a Mood Matrix noise animation, consisting of the steps:

- A noise animation sound effect specified by `sound_code` is played (see below).
- The noise UI is animated in. If `from` is specified, then the initial noise level is that integer percent; otherwise, it is the last value displayed.
- The noise is changed from the current value (or the value specified by `from`) to the value specified by `to`.
- If the `sound_code` ends with `_0`, an extra "noise cleared" animation is played.
- The noise UI is animated out.

The valid sound codes are:

- `100_0` - Played when the noise level goes from 100% to 0%.
- `100_m` - Played when the noise level goes from 100% to a medium-sized value (like 50%).
- `100_s` - Played when the noise level goes from 100% to a small value (like 20%).
- `m_0` - For when the noise level goes from a medium-sized value to 0%.
- `m_100` - For when the noise level goes from a medium-sized value to 100%.
- `m_s` - For when the noise level goes from a medium-sized value to a small value.
- `s_0` - For when the noise level goes from a small value to 0%.
- `s_m` - For when the noise level goes from a small value to a medium-sized value.

Again, note that for the sound codes ending in `_0` (i.e., those where the final noise level is 0%), an extra animation will play to align with the sound effect.

```xml
<mood_matrix.noise.set_level level="int" />
```

Sets the noise level percentage to `level`.
This does not automatically cause the noise UI to display.

```xml
<mood_matrix.noise.set_visible value="bool:true" />
```

Sets the noise UI to be instantly visible or invisible, depending on `value`, with no animation.

```xml
<mood_matrix.noise.set_label text="string:NOISE LEVEL" />
```

Sets the label for the noise UI to `text`.
By default, this is `NOISE LEVEL`, to match the games.

```xml
<mood_matrix.noise.animate_in />
```

Plays the appear animation for the noise UI, and leaves it on-screen.

```xml
<mood_matrix.noise.animate_out />
```

Plays the disappear animation for the noise UI, removing it from view.

```xml
<mood_matrix.noise.animate_level from="int" to="int" />
```

Animates the noise level percentage from the value provided as `from` to the value provided as `to`.
If no value is provided for `from`, then the last value displayed in the UI is used.

#### Shutdown animation

```xml
<mood_matrix.shutdown text="string:BYE BYE" />
```

Plays the Mood Matrix shutdown animation. If no text is provided, "BYE BYE" is displayed as in the games.

## Data types

### `color`

Colors can be an HTML color code (like `#385A8B`) or a case-insensitive named color.
(Internally, [the Godot `Color.from_string` method](https://docs.godotengine.org/en/stable/classes/class_color.html#class-color-method-from-string) is used, so check that for more information.)

In addition, there are a few case-*sensitive* colors provided to match the *Ace Attorney* games:

- `aa-text-red` is the text color used to highlight important words and phrases.
- `aa-text-blue` is the text color used for characters' inner thoughts.
- `aa-text-green` is the text color used for phone calls and other "indirect" communications.
- `aa-witintro-red` is the text color used for the "Cross Examination" title that appears before cross-examining a witness.
- `aa-witintro-blue` is the text color used for the "Witness Testimony" title that appears before hearing testimony.
