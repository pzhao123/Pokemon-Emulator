 breed [gymleaders gymleader]
patches-own [oricolor              newcolor                shiftedcolor     ]
;          original color         color after change               color after shift ]
; pt_ means for Pallet Town

globals [vertical          horizontal           PalletTown?  Route1? SandgemTown?          centerx                centery comingto comingback spawning
;     vertical change   horizontal change    r u in PalletTown     center on x axis?     center on y axis?
         motion              ingrass?          flyhacks
;  did the player move?     are you in grass
         playerTurn? Battle? GymBattle? currentPokemon numPokemon Wildbattle? TotalWildPoke WildPokeNum wildLevel wildAttack wildOriHealth wildHealth wildgiveExp WildPokeName
  Poke1Name Poke1Level Poke1Attack Poke1Health Poke1OriHealth Poke1Exp Poke2Name Poke2Level Poke2Attack Poke2Health Poke2OriHealth Poke2Exp switched? opponentAttacked? ]

;world size: 200 x 200

to setup
  ca
   crt 1 [set shape "front" setxy 100 100 set size 7 set color black set heading 0]
  setupPalletTown
  setupModes
  graybox ask patches [ set pcolor shiftedcolor ]
  ask patch 137 160 [ set plabel-color black set plabel "YOU ARE IN PALLET TOWN" ]
  ask turtle 0 [ set color 29.3 ]
end

to setupModes
  set battle? false
  set Poke1Name "PIKACHU"
  set wildBattle? false
  set GymBattle? false
  setupPoke1 5
  set numPokemon 1
  set Poke1Exp 0
  set currentPokemon 1
  set playerturn? false
end

to toggleflyhacks
  ifelse flyhacks = true
  [ set flyhacks false ]
  [ set flyhacks true ]
end

to setupPalletTown
  ask gymleaders [ die ]
  set PalletTown? true set SandgemTown? false set Route1? false
  ask turtle 0 [set hidden? true]
  set vertical 0 set horizontal 0
  blackbox graybox
  import-pcolors "bPalletTown.PNG"
  ask patches [set oricolor pcolor set newcolor pcolor set shiftedcolor pcolor ]
  if spawning = true
  [ ask turtle 0 [setxy 100 100] ]
  if comingto = true
  [
    ask turtle 0 [
    setxy 100 100  ]
  repeat 9 [ move_Up -3 3 9  ]
]
    blackbox graybox
  ask patches [set pcolor shiftedcolor]
  narration
  ask turtle 0 [set hidden? false]
  set comingto false
  set spawning false
  setupPoke1 Poke1Level
  if numPokemon = 2 [setupPoke2 Poke2Level]
  set battle? false
  set playerTurn? false
end

to setupSandgemTown
  if any? gymleaders [
    ask gymleaders [ die ] ]
  set PalletTown? false set SandgemTown? true set Route1? false
  ask turtle 0 [set hidden? true]
  set vertical 0 set horizontal 0
    blackbox graybox
  import-pcolors "bSandgemTown.PNG"
  ask patches [set oricolor pcolor set newcolor pcolor set shiftedcolor pcolor ]; ask patches [ set pcolor shiftedcolor ]
  if comingto = true
  [ask turtle 0 [set hidden? true setxy 100 100 set shape "rightside" set size 9]
    repeat 2 [move_up -3 3 9]
    repeat 14 [move_left 1 -1 -14]
  ]
  narration
  ask turtle 0 [set hidden? false]
  set comingto false
  setupPoke1 Poke1Level
  if numPokemon = 2 [setupPoke2 Poke2Level]
  set battle? false
  set playerTurn? false
  ask patch 138 101 [ sprout-gymleaders 1 [ set size 9 set shape "brawly2" set color 29.3]]
end

to setupRoute1
  ask gymleaders [die ]
  set PalletTown? false set SandgemTown? false set Route1? true
  ask turtle 0 [set hidden? true]
  set vertical 0 set horizontal 0
  ;blackbox graybox
  import-pcolors "bRoute1.PNG"
  ask patches [set oricolor pcolor set newcolor pcolor set newcolor pcolor] ; ask patches [ set pcolor oricolor ]
  ask turtle 0 [
    setxy 100 100 ]
  if comingto = true [
      repeat 9 [move_down 4 -2 -9 ]
      repeat 10 [move_right -1 1 12 ]
  ]
  if comingback = true [
    repeat 5 [move_left 1 -1 -13]
    repeat 9 [move_up -2 4 11]
    repeat 5 [move_right -1 1 12]
    move_up -2 4 11
    ask turtle 0 [set shape "front" set size 7]
  ]
  ask turtle 0 [set hidden? false]
  narration
  set comingto false
  set comingback false
  set battle? false
  set playerTurn? false
end

to narration
  clear
  if PalletTown? = true [clear
    ask patch 137 160 [set plabel-color black set plabel "YOU ARE IN PALLET TOWN" ]
  ]
  if Route1? = true and battle? = false [clear
    ask patch 130 160 [set plabel-color black set plabel "YOU ARE IN ROUTE 1" ]
  ]
  if SandgemTown? = true and battle? = false [clear
    ask patch 140 160 [set plabel-color black set plabel "YOU ARE IN SANDGEM TOWN" ]
  ]
end

to clear
  ask patches [set plabel "" set plabel-color black]
end

to center?
  ask (turtle 0) [
   ifelse pycor = 100
    [ set centery true ]
    [ set centery false ]
   ifelse pxcor = 0
    [ set centerx true ]
    [ set centerx false ]
  ]
end

to motionTrue
  set motion true
end
to motionFalse
  set motion false
end
;becomes true after the turtle "moves" (either by the world shifting or by the turtle moving,
; resets to false at the end of every "move" program

to blackbox  ; blocks out to make map
  ask patches [if pxcor < (10 + 20)or pxcor > (190 - 23) or pycor <= (50 + 10) or pycor > (170 - 35)[set shiftedcolor black]]
end

to graybox ; makes narration box
 if battle? = false [
    ask patches [if pxcor >= 10 and pxcor <= 190 and pycor > 150 and pycor <= 170 [set shiftedcolor 7]] ]
 if battle? = true [
    ask patches [if pxcor >= 10 and pxcor <= 190 and pycor > 150 and pycor <= 170 [set pcolor 7]] ]
end

to GoToNewPlaces [ a ]
  if a = 1 [ set PalletTown? true set Route1? false set SandgemTown? false narration set comingto true setupPalletTown]
  if a = 2 [  set Route1? true set SandgemTown? false narration
    ifelse PalletTown? = true
    [ set PalletTown? false set comingto true set comingback false setupRoute1 ]
    [ set PalletTown? false set comingto false set comingback true setupRoute1 ]
  ]
  if a = 3 [ set PalletTown? false set Route1? false set SandgemTown? true narration set comingto true setupSandgemTown]
end


to moveUp
if battle? = false [
    ask turtle 0 [set shape "back" set size 7]
; palletTown
 if PalletTown? = true and (
    (vertical >= 3 and vertical <= 8 and horizontal >= 0 and horizontal <= 2) or ;exit
    (horizontal >= -12 and horizontal <= 12 and vertical >= 6 and vertical <= 7) or ;left corner
    (horizontal >= 9 and horizontal <= 12 and vertical >= 0 and vertical <= 7) or ;right corner
    (horizontal >= 10 and horizontal <= 12 and vertical >= -10 and vertical <= 0) or ;bottom right corner
    (horizontal >= -12 and horizontal <= -10 and vertical >= 3 and vertical <= 7) or ;top left side
    (horizontal >= -12 and horizontal <= -11 and vertical >= -10 and vertical <= 2) or ;bottom left side
    (horizontal >= -10 and horizontal <= 0 and vertical >= -1 and vertical <= 1) or ;middle left
    (horizontal >= 1 and horizontal <= 8 and vertical >= 0 and vertical <= 1) or ;middle right
    (horizontal >= -2 and horizontal <= 0 and vertical >= 1 and vertical <= 6) or ;middle top
    (horizontal >= -1 and horizontal <= 12 and vertical >= -10 and vertical <= -8) or ;bottom right corner
    (horizontal >= -2 and horizontal <= 0 and vertical >= -7 and vertical <= -2) or ;bottom middle
    (horizontal >= 1 and horizontal <= 10 and vertical >= -6 and vertical <= -6) or ;middle bottom right corner
    (horizontal = 9 and vertical = -7) or ;right of corner fence
    (horizontal = -10 and (vertical = -3 or vertical = -2)) or ;left of left fence
    (horizontal >= -10 and horizontal <= -7 and vertical >= -10 and vertical <= -3) or ;left of pond
   (horizontal >= -6 and horizontal <= -2 and vertical >= -7 and vertical <= -3) or ;above the pond
    (flyhacks = true)
  )
  [ move_up -3 3 9 ]
; num1: when person stops walking up when returning from bottom of location
; num2: when person starts walking up when going toward top of map
; num3: most "up" border of map
  if Route1? = true and (
    (vertical = -9 ) or; bottom rectangle right
    (vertical <= -8 and horizontal <= -2 and horizontal >= -4) or; bottom rectangle middle
    (vertical <= -8 and horizontal = -10) or; bottom left
    (vertical >= -7 and vertical <= -5) or; second giant box from bottom
    (vertical >= -5 and vertical <= 8 and horizontal >= 5) or; move up from right side in second giant box
    (horizontal <= -3 and horizontal >= -10 and vertical = -4) or ; move up to touch ridge second box from bottom
    (vertical = -1) or; third giant horizontal box from bottom
    (vertical = 0 and horizontal <= -6) or; move up to ridge from third giant horizontal box
    (vertical >= 0 and horizontal >= -2 and vertical <= 4) or; patch of grass
    (vertical >= 7 and (horizontal >= -2 or horizontal <= -3) and vertical <= 8) or; top rectangle
    (vertical >= 7 and horizontal >= -2 and horizontal <= 2) or; exit
    (vertical >= 3 and horizontal <= -6 and (vertical <= 4 or vertical != 6)) or; ridge compartment
    (flyhacks = true)
   )
  [move_up -2 4 11]
  if SandgemTown? = true and (
    ((vertical = 0 or vertical = 1) and horizontal = 0) or ;to escape the house during setup
    (vertical >= 2 and vertical <= 2 and horizontal >= -14 and horizontal <= 13) or ;middle horizontal path
    (vertical >= -6 and vertical <= 1 and horizontal >= -7 and horizontal <= -5) or ;left vertical path
    (vertical >= -6 and vertical <= -5 and horizontal >= -13 and horizontal <= 9) or ;bottom horizontal path
    (vertical >= 7 and vertical <= 8 and horizontal >= 8 and horizontal <= 13) or ;top right corner
    (vertical >= 4 and vertical <= 8 and horizontal >= 3 and horizontal <= 9) or ;middle top right
    (vertical >= -9 and vertical <= -5 and horizontal >= 3 and horizontal <= 9) or ;bottom sand
    (vertical >= -3 and vertical <= 1 and horizontal >= 4 and horizontal <= 13) or ;under right horizontal path
    (vertical >= -4 and vertical <= 1 and horizontal >= 7 and horizontal <= 13) or ;bottom right corner
    (vertical >= -5 and vertical <= -2 and horizontal = 4) or ;left of post
    (vertical >= 2 and vertical <= 8 and horizontal >= 4 and horizontal <= 8) or ;upper end of path
    (flyhacks = true)
    )
  [move_up -3 3 9 if any? gymleaders and vertical >= -2 and vertical <= 3 [ ask gymleaders [ set heading 180 fd 5 ] ] ]
    if Route1? = true and vertical >= 10 and horizontal <= 1 [GoToNewPlaces 3]
    if PalletTown? = true and vertical = 9 and horizontal <= 1[ GoToNewPlaces 2 ]
    interact
  ]
end

to moveDown
  If battle? = false [
    ask turtle 0 [set shape "front" set size 7]
  ;palletTown
 if PalletTown? = true and (
    (vertical >= 5 and vertical <= 9 and horizontal >= 0 and horizontal <= 2) or ;exit
    (horizontal >= -12 and horizontal <= 12 and vertical >= 8 and vertical <= 8) or ;top horizontal path
    (horizontal >= 9 and horizontal <= 12 and vertical >= 2 and vertical <= 8) or ;top right corner
    (horizontal >= 10 and horizontal <= 12 and vertical >= -9 and vertical <= 1) or ;bottom right corner
    (horizontal >= -12 and horizontal <= -10 and vertical >= 5 and vertical <= 7) or ;top left side
    (horizontal >= -12 and horizontal <= -11 and vertical >= -9 and vertical <= 4) or ;bottom left side
    (horizontal >= -10 and horizontal <= 0 and vertical >= 0 and vertical <= 2) or ;middle left
    (horizontal >= 1 and horizontal <= 8 and vertical >= 2 and vertical <= 2) or ;middle right
    (horizontal >= -2 and horizontal <= 0 and vertical >= 1 and vertical <= 7) or ;middle top
    (horizontal >= -1 and horizontal <= 12 and vertical >= -9 and vertical <= -7) or ;bottom right corner
    (horizontal >= -2 and horizontal <= 0 and vertical >= -6 and vertical <= -1) or ;bottom middle
    (horizontal >= 1 and horizontal <= 10 and vertical >= -5 and vertical <= -4) or ;middle bottom right corner
    (horizontal = 9 and vertical = -6) or ;right of corner fence
    (horizontal = -10 and (vertical = -2 or vertical = -1)) or ;left of left fence
    (horizontal >= -10 and horizontal <= -7 and vertical >= -9 and vertical <= -2) or ;left of pond
    (horizontal >= -6 and horizontal <= -2 and vertical >= -6 and vertical <= -2) or;above the pond
    (flyhacks = true)
    )
  [ move_down 3 -3 -10 ]
  if Route1? = true
  and (
    (vertical <= 11 and vertical >= 10) or; exit
    ((horizontal >= -2 or horizontal <= -6 ) and vertical >= 0 and vertical >= 1) or (vertical = 0) or; top rectangle
    (horizontal >= 5) or; right side
    (horizontal <= -3 and horizontal >= -10 and vertical <= -1) or; row of trees middle
    (vertical <= -4) or; bottom giant box
    (flyhacks = true)
    )
  [ move_down 4 -2 -9]
  if SandgemTown? = true and (
    (vertical >= 3 and vertical <= 3 and horizontal >= -14 and horizontal <= 13) or ;middle horizontal path
    (vertical >= -5 and vertical <= 3 and horizontal >= -7 and horizontal <= -5) or ;left vertical path
    (vertical >= -5 and vertical <= -4 and horizontal >= -13 and horizontal <= 9) or ;bottom horizontal path
    (vertical >= 9 and vertical <= 10 and horizontal >= 8 and horizontal <= 13) or ;top right corner
    (vertical >= 6 and vertical <= 9 and horizontal >= 6 and horizontal <= 9) or ;middle top right
    (vertical >= -8 and vertical <= -4 and horizontal >= 3 and horizontal <= 9) or ;bottom sand
    (vertical >= -1 and vertical <= 3 and horizontal >= 4 and horizontal <= 13) or ;under right horizontal path
    (vertical >= -3 and vertical <= 3 and horizontal >= 7 and horizontal <= 13) or ;bottom right corner
    (vertical >= -6 and vertical <= 3 and horizontal = 4) or ;left of post
    (vertical >= 2 and vertical <= 9 and horizontal >= 4 and horizontal <= 8) or;upper end of path
    (flyhacks = true)
    )
  [ move_down 3 -3 -9 if any? gymleaders and vertical >= -3 and vertical <= 2 [ ask gymleaders [ set heading 0 fd 5 ] ] ]
  if Route1? = true and vertical = -9 and horizontal >= 8 [GoToNewPlaces 1 ]
  interact
  ]
end

to moveLeft
  If battle? = false [
    ask turtle 0 [set shape "leftside" set size 9]
; PalletTown
 if PalletTown? = true and (
    (vertical >= 3 and vertical <= 9 and horizontal >= 1 and horizontal <= 2) or ;exit
    (horizontal >= -11 and horizontal <= 12 and vertical >= 7 and vertical <= 8) or ;top horizontal path
    (horizontal >= 10 and horizontal <= 12 and vertical >= 1 and vertical <= 7) or ;right corner
    (horizontal >= 11 and horizontal <= 12 and vertical >= -10 and vertical <= 0) or ;bottom right corner
    (horizontal >= -11 and horizontal <= -10 and vertical >= 3 and vertical <= 7) or ;top left side
    (horizontal >= -11 and horizontal <= -12 and vertical >= -10 and vertical <= 2) or ;bottom left side
    (horizontal >= -11 and horizontal <= 1 and vertical >= -1 and vertical <= 2) or ;middle left
    (horizontal >= 1 and horizontal <= 10 and vertical >= 1 and vertical <= 2) or ;middle right
    (horizontal >= -1 and horizontal <= 1 and vertical >= 1 and vertical <= 6) or ;middle top
    (horizontal >= 0 and horizontal <= 12 and vertical >= -10 and vertical <= -8) or ;bottom right corner
    (horizontal >= -1 and horizontal <= 1 and vertical >= -7 and vertical <= -2) or ;bottom middle
    (horizontal >= 1 and horizontal <= 10 and vertical >= -6 and vertical <= -5) or ;middle bottom right corner
    (horizontal = 10 and vertical = -7) or ;right of corner fence
    (horizontal = -10 and (vertical = -3 or vertical = -2)) or ;left of left fence
    (horizontal >= -12 and horizontal <= -7 and vertical >= -10 and vertical <= -3) or ;left of pond
    (horizontal >= -6 and horizontal <= -1 and vertical >= -7 and vertical <= -3)or ;above the pond
    (flyhacks = true)
    )
  [ move_left 1 -1 -12 ]
  if Route1? = true and (
   (vertical <= -8) or; bottom rectangle
   (vertical = -7 and horizontal >= -3 and horizontal <= -2) or; between ridges bottom middle
   (vertical <= -4 and vertical >= -6) or; second giant box
   (vertical = -3 and horizontal <= -3 and horizontal >= -9) or ; middle ridge
   (horizontal >= 6 ) or ; right giant box
   (vertical >= -1 and vertical < 1) or; third giant horizontal box
   (vertical = 1 and horizontal >= -12 and horizontal <= -6)or; bottom ridge of ridge box
   (vertical = -2 and horizontal <= -3 and horizontal >= -9) or; top of ridge on second box from bottom
   (horizontal >= -1 and vertical >= 1 and vertical <= 8 ) or ;tree collumn
   (horizontal >= -1 and vertical >= 10 ) or; exit
   (horizontal <= -6 and vertical >= 1) or; ridge compartment
   (vertical = 9) or; top rectangle
   (flyhacks = true)
   )
  [move_left 1 -1 -13]
  if SandgemTown? = true and (
    (vertical >= 2 and vertical <= 3 and horizontal >= -13 and horizontal <= 13) or ;middle horizontal path
    (vertical >= -6 and vertical <= 2 and horizontal >= -6 and horizontal <= -5) or ;left vertical path
    (vertical >= -6 and vertical <= -4 and horizontal >= -12 and horizontal <= 9) or ;bottom horizontal path
    (vertical >= 7 and vertical <= 9 and horizontal >= 9 and horizontal <= 13) or ;top right corner
    (vertical >= 5 and vertical <= 9 and horizontal >= 4 and horizontal <= 9) or ;middle top right
    (vertical >= -9 and vertical <= -4 and horizontal >= 4 and horizontal <= 9) or ;bottom sand
    (vertical >= -2 and vertical <= 2 and horizontal >= 5 and horizontal <= 13) or ;under right horizontal path
    (vertical >= -4 and vertical <= 2 and horizontal >= 8 and horizontal <= 13) or ;bottom right corner
    (vertical >= -3 and vertical <= -2 and horizontal = 5) or ;left of post
    (vertical >= 2 and vertical <= 8 and horizontal >= 5 and horizontal <= 8)or ;upper end of path
    (flyhacks = true )
    )
  [move_left 1 -1 -14  if SandgemTown? = true and any? gymleaders and horizontal >= -1 and horizontal <= 0 [ ask gymleaders [ set heading 90 fd 5 ] ]]
  if SandgemTown? = true and vertical = 2 and horizontal = -14 [GoToNewPlaces 2 ]
  interact
  ]
end

to moveRight
  if battle? = false [
    ask turtle 0 [set shape "rightside" set size 9]
 ;PalletTown
 if PalletTown? = true and (
    (vertical >= 4 and vertical <= 9 and horizontal >= 0 and horizontal <= 1) or ;exit
    (horizontal >= -12 and horizontal <= 11 and vertical >= 7 and vertical <= 8) or ;top horizontal path
    (horizontal >= 9 and horizontal <= 11 and vertical >= 1 and vertical <= 7) or ;right corner
    (horizontal >= 10 and horizontal <= 11 and vertical >= -10 and vertical <= 0) or ;bottom right corner
    (horizontal >= -12 and horizontal <= -11 and vertical >= 4 and vertical <= 7) or ;top left side
    (horizontal >= -12 and horizontal <= -11 and vertical >= -10 and vertical <= 3) or ;bottom left side
    (horizontal >= -10 and horizontal <= -1 and vertical >= -1 and vertical <= 2) or ;middle left
    (horizontal >= -1 and horizontal <= 11 and vertical >= 1 and vertical <= 2) or ;middle right
    (horizontal >= -2 and horizontal <= -1 and vertical >= 1 and vertical <= 6) or ;middle top
    (horizontal >= 0 and horizontal <= 11 and vertical >= -10 and vertical <= -8) or ;bottom right corner
    (horizontal >= -2 and horizontal <= -1 and vertical >= -7 and vertical <= -2) or ;bottom middle
    (horizontal >= -1 and horizontal <= 11 and vertical >= -6 and vertical <= -5) or ;middle bottom right corner
    (horizontal = 9 and vertical = -7) or ;right of corner fence
    (horizontal = -10 and (vertical = -3)) or ;left of left fence
    (horizontal >= -12 and horizontal <= -8 and vertical >= -10 and vertical <= -3) or ;left of pond
    (horizontal >= -7 and horizontal <= -1 and vertical >= -7 and vertical <= -3) or ;above the pond
    (flyhacks = true)
    )
  [move_right -1 1 12 ]
  if Route1? = true  and (
    (vertical <= -8) or; bottom rectangle
    (vertical = -7 and horizontal >= -4 and horizontal <= -1)or; second giant box
    (vertical = -7 and horizontal <= -1 and horizontal >= -3) or ; middle ridge
    (vertical = -3 and horizontal <= -4 and horizontal >= -10 ) or ; ridge of second giant box from bottom
    (vertical <= -4 and vertical >= -6) or; second giant box
    (horizontal >= 5 ) or ; right giant box
    (vertical >= -1 and vertical < 1) or; third giant horizontal box
    (vertical = 1 and horizontal >= -13 and horizontal <= -7)or; bottom ridge of ridge box
    (vertical = -2 and horizontal <= -4 and horizontal >= -10) or; top of ridge on second box from bottom
    (horizontal >= -2 and vertical >= 1 and vertical <= 9 ) or ;touching tree column
    (vertical = 9) or; top rectangle
    (horizontal <= -7 and vertical >= 1) or; ridge compartment
    (horizontal >= -2 and horizontal <= 1 and vertical >= 10 ) or; exit
    (flyhacks = true)
  )
  [move_right -1 1 12]
  if SandgemTown? = true and (
    (vertical >= 2 and vertical <= 3 and horizontal >= -14 and horizontal <= 12) or ;middle horizontal path
    (vertical >= -6 and vertical <= 2 and horizontal >= -7 and horizontal <= -6) or ;left vertical path
    (vertical >= -6 and vertical <= -4 and horizontal >= -13 and horizontal <= 8) or ;bottom horizontal path
    (vertical >= 7 and vertical <= 9 and horizontal >= 7 and horizontal <= 12) or ;top right corner
    (vertical >= 5 and vertical <= 9 and horizontal >= 3 and horizontal <= 8) or ;middle top right
    (vertical >= -9 and vertical <= -4 and horizontal >= 3 and horizontal <= 8) or ;bottom sand
    (vertical >= -2 and vertical <= 2 and horizontal >= 3 and horizontal <= 12) or ;under right horizontal path
    (vertical >= -4 and vertical <= 2 and horizontal >= 6 and horizontal <= 12) or ;bottom right corner
    (vertical >= -3 and vertical <= -2 and horizontal = 5) or ;left of post
    (vertical >= 2 and vertical <= 8 and horizontal >= 4 and horizontal <= 7) or ;upper end of path
    (flyhacks = true)
    )
    [move_right -1 1 13     if SandgemTown? = true and any? gymleaders and horizontal >= 0 and horizontal <= 1 [ ask gymleaders [ set heading 270 fd 5 ] ] ]
    interact
  ]
end

to move_up [ a b c ]
; num1: when person stops walking up when returning from bottom of location
; num2: when person starts walking up when going toward top of map
; num3: most "up" border of map
    ifelse (vertical) >= a and vertical < b
; first part of ifelse for when the world is moving
      [
       ask patches [
         ifelse pycor <= 194
           [set shiftedcolor ([newcolor] of patch (pxcor) (pycor + 5))]
           [ ifelse vertical > 0
             [set shiftedcolor black]
             [set shiftedcolor [oricolor] of patch (pxcor +  (horizontal * 5)) (pycor + (vertical * 5))]
          ]
       ]
       motionTrue
       ask patches [
      set newcolor shiftedcolor ]
         blackbox
         graybox
      ask patches [set pcolor shiftedcolor]
    ]
; second part of if for when turtle is moving
     [
      center?
      if (centery = false ) or vertical >= a [
        if vertical < c [
          ask turtle 0 [setxy xcor (ycor + 5 )]
        ]
        motionTrue
      ]
    ]
  if vertical != c and motion = true [
    set vertical (vertical + 1)
    narration]
    motionFalse
  CheckGrass
  if random 100 < 15 and ingrass? = true [ battlescene ]
end

to move_down [ a b c ]
   ifelse (vertical) <= a and vertical > b
      [ ask patches [ ifelse pycor >= 5
      [set shiftedcolor ([newcolor] of patch (pxcor) (pycor - 5)) ]
      [ ifelse vertical < 0
      [set shiftedcolor black]
      [set shiftedcolor [oricolor] of patch (pxcor + (horizontal * 5)) (pycor + (vertical * 5))]
    ]]motionTrue   ask patches [
        set newcolor shiftedcolor ]
    blackbox
    graybox
  ask patches [
    set pcolor shiftedcolor
  ]]
      [ center? if (centery = false ) or vertical <= a
      [ if vertical > c
      [ask turtle 0 [
        setxy xcor (ycor - 5)
      ]]motionTrue
      ]]
  if vertical != c and motion = true [ set vertical (vertical - 1)
    narration ]
      motionFalse
  CheckGrass
  if random 100 < 15 and ingrass? = true [ battlescene ]
end

to move_left [ a b c ]
    ifelse horizontal <= a and horizontal > b
  [ ask patches [
      ifelse pxcor >= 5
      [set shiftedcolor ([newcolor] of patch (pxcor - 5) (pycor)) ]
      [ifelse horizontal < 0
        [set shiftedcolor black]
        [set shiftedcolor [oricolor] of patch (pxcor + (horizontal * 5)) (pycor + (vertical * 5))]
  ]]motionTrue
  ask patches [
      set newcolor shiftedcolor ]
    blackbox
    graybox
  ask patches [
    set pcolor shiftedcolor
  ]]
    [ center? if (centerx = false ) or horizontal <= a
      [if horizontal > c
      [ask turtle 0 [
        setxy (xcor - 5) ycor
      ]]motionTrue
      ]]
  if horizontal != c and motion = true [ set horizontal (horizontal - 1)
    narration ]
  motionFalse
  CheckGrass
  if random 100 < 15 and ingrass? = true [ battlescene ]
end

to move_right [ a b c ]
    ifelse horizontal >= a and horizontal < b
  [ ask patches [
    ifelse pxcor <= 194
      [set shiftedcolor ([newcolor] of patch (pxcor + 5) (pycor)) ]
      [ifelse horizontal > 0
        [set shiftedcolor black]
        [set shiftedcolor [oricolor] of patch (pxcor + (horizontal * 5)) (pycor + (vertical * 5))]
    ]
  ]
  motionTrue
  ask patches [
      set newcolor shiftedcolor ]
    blackbox
    graybox
  ask patches [
    set pcolor shiftedcolor
  ]
  ]
   [ center? if (centerx = false ) or horizontal >= a
      [if horizontal < c
      [ask turtle 0 [
        setxy (xcor + 5) ycor
      ]]motionTrue
      ]]
  if horizontal != c and motion = true [ set horizontal (horizontal + 1)
  narration ]
  motionFalse
  CheckGrass
  if random 100 < 15 and ingrass? = true [ battlescene ]
end

to interact
  if [ any? gymleaders in-radius 5 ] of turtle 0 = true
  [ set gymbattle? true battlescene ]
end

to CheckGrass
  ifelse Route1? = true and
    ((vertical <= -1 and vertical >= -3 and horizontal >= 6 and horizontal <= 12) or ; bottom grass patch
    (vertical <= 5 and vertical >= 3 and horizontal >= -3 and horizontal <= 12)) ; top grass patch
  [  set ingrass? true set wildBattle? true]
  [  set ingrass? false set wildBattle? true]
end



To setupWild
  If numPokemon = 1 [
     if Poke1Level mod 2 = 1 [Set wildLevel ((Poke1Level + 1) * (.5) ) + random 3]
     If Poke1Level mod 2 = 0 [Set wildLevel (Poke1Level * (.5)) + random 3]
]
  If numPokemon = 2 [
     if (Poke1Level + Poke2Level) mod 2 = 1 [Set wildLevel ((Poke1Level + Poke2Level + 1) * (.5) ) + random 3]
     If (Poke1Level + Poke2Level) mod 2 = 0 [Set wildLevel ((Poke1Level + Poke2Level)* (.5)) + random 3]
]
  Set wildAttack (5 * (wildLevel) + 15) / 4
  Set wildHealth (5 * (wildLevel) + 15)
  Set wildOriHealth wildHealth
  Set wildgiveExp ((wildLevel - 2) * 10)
  set wildBattle? true
end

To setupPoke1 [lvl]
  Set Poke1Level lvl
  Set Poke1Attack (5 * (lvl) + 15) / 4
  Set Poke1Health (5 * (lvl) + 15)
  Set Poke1OriHealth Poke1Health
end

To setupPoke2 [lvl]
  Set Poke2Level lvl
  Set Poke2Attack (5 * (lvl) + 15) / 4
  Set Poke2Health (5 * (lvl) + 15)
  Set Poke2OriHealth Poke1Health
end

To makeStats1 [lvl]
  set Poke1Level lvl
  Set Poke1Attack (5 * (lvl) + 15) / 4
  set Poke1OriHealth (5 * (lvl) + 15)
end

To makeStats2 [lvl]
  set Poke2Level lvl
  Set Poke2Attack (5 * (lvl) + 15) / 4
  set Poke2OriHealth (5 * (lvl) + 15)
end

to battlescene
  if gymbattle? = true [
    set battle? true
ToggleBattle
    import-pcolors "gymleader.jpg" wait 3
    set wildPokeNum (random 2) + 1
    if currentPokemon = 1 [
    If poke1name = "CHARMANDER"
	    [if wildPokeNum = 1 [ set wildpokename "CHARMANDER" import-pcolors "cvsc.png" ]
      if wildPokeNum = 2 [ set wildpokename "PIKACHU" import-pcolors  "cvsp.png" ] ]
    if poke1name = "PIKACHU"
           [ if wildPokeNum = 1  [ set wildpokename "CHARMANDER" import-pcolors "pvsc.png" ]
              if wildPokeNum = 2 [ set wildpokename "PIKACHU" import-pcolors  "pvsp.png" ] ]
    ]
    if currentPokemon = 2 [
      If poke2name = "CHARMANDER"
	    [if wildPokeNum = 1 [set wildpokename "CHARMANDER" import-pcolors "cvsc.png" ]
      if wildPokeNum = 2 [ set wildpokename "PIKACHU" import-pcolors  "cvsp.png" ] ]
    if poke2name = "PIKACHU"
           [ if wildPokeNum = 1  [ set wildpokename "CHARMANDER" import-pcolors "pvsc.png" ]
              if wildPokeNum = 2 [ set wildpokename "PIKACHU" import-pcolors  "pvsp.png" ] ]
    ]
set wildLevel 25
      Set wildAttack (5 * (wildLevel) + 15) / 4
  Set wildHealth (5 * (wildLevel) + 15)
  Set wildOriHealth wildHealth
  Set wildgiveExp ((wildLevel - 2) * 10)
    graybox
    set playerTurn? true
      makeStats1 Poke1Level
  if numPokemon = 2 [makeStats2 Poke2Level]
    graybox
  clear
  experiencebar HealthBars levelNumbers Pokenames
  if gymBattle? = true [ ask patch 142 160 [set plabel-color black set plabel (word "BRAWLY SENT OUT " wildpokename " !") ] wait 2]
  ]
  if gymbattle? = false
  [
Set battle? true
  graybox
ToggleBattle
If wildBattle? = true [
    set wildPokeNum (random 2) + 1
    if currentPokemon = 1 [
    If poke1name = "CHARMANDER"
	    [if wildPokeNum = 1 [ set wildpokename "CHARMANDER" import-pcolors "cvsc.png" ]
      if wildPokeNum = 2 [ set wildpokename "PIKACHU" import-pcolors  "cvsp.png" ] ]
    if poke1name = "PIKACHU"
           [ if wildPokeNum = 1  [ set wildpokename "CHARMANDER" import-pcolors "pvsc.png" ]
              if wildPokeNum = 2 [ set wildpokename "PIKACHU" import-pcolors  "pvsp.png" ] ]
    ]
    if currentPokemon = 2 [
      If poke2name = "CHARMANDER"
	    [if wildPokeNum = 1 [set wildpokename "CHARMANDER" import-pcolors "cvsc.png" ]
      if wildPokeNum = 2 [ set wildpokename "PIKACHU" import-pcolors  "cvsp.png" ] ]
    if poke2name = "PIKACHU"
           [ if wildPokeNum = 1  [ set wildpokename "CHARMANDER" import-pcolors "pvsc.png" ]
              if wildPokeNum = 2 [ set wildpokename "PIKACHU" import-pcolors  "pvsp.png" ] ]
    ]
    setupWild
    graybox
    set playerTurn? true
  ]
  makeStats1 Poke1Level
  if numPokemon = 2 [makeStats2 Poke2Level]
  clear
  experiencebar HealthBars levelNumbers Pokenames
  if wildBattle? = true [ ask patch 142 160 [set plabel-color black set plabel (word "A WILD " wildpokename " APPEARED!") ] ]
]
end

to HealthBars
If currentPokemon = 1 [
  ask patches with [( pxcor >= 150 and pycor >= 62 and pycor <= 63 and pxcor <= 180 ) or
    (pxcor >= 47 and pycor >= 118 and pycor <= 119 and pxcor <= 77 )] [ set pcolor black ]
  ask patches with [pxcor >= 150 and pycor >= 62 and pycor <= 63 and pxcor <=  150 + (( Poke1Health / Poke1OriHealth ) * 30) ] [; bottom bar
     if Poke1Health > 0 [
     if ( Poke1Health / Poke1OriHealth ) > 0.5 [ set pcolor green ]
     if ( Poke1Health / Poke1OriHealth ) <= 0.5 and ( Poke1Health / Poke1OriHealth ) > 0.2 [ set pcolor yellow ]
     if ( Poke1Health / Poke1OriHealth ) <= 0.2 [ set pcolor red ]
    ]]
Ask patch 175 57 [ set plabel-color black set plabel ( word Poke1Health "/ " Poke1OriHealth )]
  ask patches with [ pxcor >= 47 and pycor >= 118 and pycor <= 119 and pxcor <= 47 + (( WildHealth / WildOriHealth ) * 30)] [ ; top bar
     if WildHealth > 0 [
     if ( WildHealth / WildOriHealth ) > 0.5 [ set pcolor green ]
     if ( WildHealth / WildOriHealth ) <= 0.5 and ( WildHealth / WildOriHealth ) > 0.2 [ set pcolor yellow ]
     if ( WildHealth / WildOriHealth ) <= 0.2 [ set pcolor red ]
    ]]
]
If currentPokemon = 2  [
  ask patches with [( pxcor >= 150 and pycor >= 62 and pycor <= 63 and pxcor <= 180 ) or
    (pxcor >= 47 and pycor >= 118 and pycor <= 119 and pxcor <= 77 )] [ set pcolor black ]
  ask patches with [pxcor >= 150 and pycor >= 62 and pycor <= 63 and pxcor <= 150 + (( Poke2Health / Poke2OriHealth) * 30) ] [; bottom bar
      if Poke2Health > 0 [
     if ( Poke2Health / Poke2OriHealth ) > 0.5 [ set pcolor green ]
     if ( Poke2Health / Poke2OriHealth ) <= 0.5 and ( Poke2Health / Poke2OriHealth ) > 0.2 [ set pcolor yellow ]
     if ( Poke2Health / Poke2OriHealth ) <= 0.2 [ set pcolor red ]
    ]]
Ask patch 175 57 [ set plabel-color black set plabel ( word Poke2Health "/ " Poke2OriHealth )]
  ask patches with [ pxcor >= 47 and pycor >= 118 and pycor <= 119 and pxcor <= 47 + ((WildHealth - (WildHealth mod 10 ))/ WildOriHealth) * 30] [ ; top bar
     if WildHealth > 0 [
     if ( WildHealth / WildOriHealth ) > 0.5 [ set pcolor green ]
     if ( WildHealth / WildOriHealth ) <= 0.5 and ( WildHealth / WildOriHealth ) > 0.2 [ set pcolor yellow ]
     if ( WildHealth / WildOriHealth ) <= 0.2 [ set pcolor red ]
    ]]
]
end


to experienceBar
If currentPokemon = 1 [
  ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 186 ] [ set pcolor random 2 + 5 ]
  ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 126 + ((Poke1Exp - Poke1Exp mod 10)/(Poke1Level * 20)) * 60 ] [ set pcolor random 2 + 85 ]
]
If currentPokemon = 2 [
  ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 186 ] [ set pcolor random 2 + 5 ]
  ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 126 + ((Poke2Exp - Poke2Exp mod 10)/(Poke2Level * 20)) * 60 ] [ set pcolor random 2 + 85 ]
]
end

to gainExperience
  ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 186 ] [ set pcolor random 2 + 5 ]
Ifelse currentPokemon = 1
[
  ifelse (Poke1Exp + ((wildLevel - 2) * 10)) >= (Poke1Level) * 20
  [ ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 126 + (((Poke1Exp + ((wildLevel - 2) * 10)) - (Poke1Level + 1) * 20)/(Poke1Level + 1)* 20) * 60 and pxcor <= 186]
    [ set pcolor random 2 + 85 ]
   set poke1Exp ((Poke1Exp + ((wildLevel - 2) * 10)) - (Poke1Level) * 20)set Poke1level (Poke1level + 1)]
  [ ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 126 + ((Poke1Exp + ((wildLevel - 2) * 10))/((Poke1Level + 1)* 20)) * 60 ]
  [ set pcolor random 2 + 85 ]
  set poke1Exp (Poke1Exp + ((wildLevel - 2) * 10))]
]
[
  ifelse (Poke2Exp + ((wildLevel - 2) * 10)) >= (Poke2Level) * 20
  [ ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 126 + (((Poke2Exp + ((wildLevel - 2) * 10)) - (Poke2Level + 1) * 20)/(Poke2Level + 1)* 20) * 60 and pxcor <= 186]
    [ set pcolor random 2 + 85 ]
   set poke2Exp ((Poke2Exp + ((wildLevel - 2) * 10)) - (Poke2Level) * 20)set Poke2level (Poke2level + 1)]
  [ ask patches with [ pxcor >= 126 and pycor = 51 and pxcor <= 126 + ((Poke2Exp + ((wildLevel - 2) * 10))/((Poke2Level + 1)* 20)) * 60 ]
  [ set pcolor random 2 + 85 ]
  set poke2Exp (Poke2Exp + ((wildLevel - 2) * 10))]
]
LevelNumbers
end

to levelNumbers
  if currentPokemon = 1 [
    ask patch 183 70 [ set plabel-color black  set plabel " " set plabel (word "Lv " Poke1Level) ]
  ]
  if currentPokemon = 2 [
      ask patch 183 70 [ set plabel-color black set plabel " " set plabel ( word "Lv " Poke2Level) ]
  ]
  ask patch 80 125 [ set plabel-color black set plabel " " set plabel ( word " Lv " WildLevel) ]
end

to PokeNames
  if currentpokemon = 1  [
    ask patch 142 70 [ set plabel-color black  set plabel " " set plabel ( word Poke1Name ) ]
  ]
  if currentPokemon = 2  [
      ask patch  ( 139 + ( length ( word Poke2Name )) * 1.3 ) 70 [ set plabel-color black set plabel " " set plabel ( word Poke2Name ) ]
  ]
  if wildPokenum =  1 [
    ask patch 55 126 [ set plabel-color black set plabel " " set plabel "CHARMANDER" ]]
  if wildPokenum =  2 [
    ask patch 42 126 [ set plabel-color black set plabel " " set plabel "PIKACHU" ]]
end




To ToggleBattle
  wait 0.5
Ifelse battle? = true
 [  Ask turtles [ set hidden? True ]  set playerTurn? True ]
 [ Ask patches [set pcolor shiftedcolor] Ask turtles [set hidden? False]
    if wildBattle? = true [set wildBattle? false] if gymBattle? = true [set gymBattle? false]]
  clear
end


to bRun
If playerTurn? = true and battle? = true[
Ifelse gymBattle? = True
[clear ask patch 130 160 [set plabel "YOU CAN’T RUN FROM A GYM BATTLE"] Wait 2]
[set playerTurn? false
      clear
  ask patch 130 160 [set plabel "YOU RAN AWAY SAFELY"]
  Wait 2
  set battle? false
  ToggleBattle ]
  ]
end

to bCatch
If playerTurn? = true and battle? = true[
Ifelse gymBattle? = True
    [clear ask patch 140 160 [ set plabel "YOU CANT USE A POKEBALL IN A GYM BATTLE"] ]
    [clear
      Ifelse numPokemon = 1 [
      Set playerTurn? False
        clear LevelNumbers Experiencebar healthbars Pokenames
       Ask patch 131 160 [set plabel "YOU USED A POKEBALL"]
       Wait 2
       Ifelse random 100 < (((wildOriHealth - WildHealth) / wildOriHealth) * 100)
         [clear LevelNumbers Experiencebar healthbars Pokenames ask patch 148 160 [set plabel-color black set plabel "YOU CAUGHT THE WILD POKEMON!"]
         wait 2 Set numPokemon 2 Set Poke2Name wildPokeName set Poke2Level wildLevel
          set Poke2Attack wildAttack set Poke2Health wildHealth set Poke2Exp 0 set Poke2OriHealth wildOriHealth
              wait 3 ask patch 140 160 [set plabel ""]
          set battle? false ToggleBattle
          ]
         [clear LevelNumbers Experiencebar healthbars Pokenames ask patch 155 160 [set plabel-color black set plabel "THE POKEMON ESCAPED THE POKEBALL!"] wait 3 ask patch 140 160 [set plabel ""]
        OpponentsTurn]
      ]
     [clear LevelNumbers Experiencebar healthbars Pokenames ask patch 165 160 [set plabel-color black set plabel "YOU CANT HAVE MORE THAN TWO POKEMON!"]  ] ]
  ]
end

to bSwitch
  if playerTurn? = true and battle? = true [
  If playerTurn? = true and numPokemon = 2 [set switched? false
    clear
    ifelse (currentPokemon = 1 and Poke2Health > 0) or (currentPokemon = 2 and Poke1Health > 0)  [
  If currentPokemon = 1 and switched? = false [set switched? true set currentPokemon 2
      ifelse Poke2Name = "PIKACHU"
      [Ifelse wildPokenum = 1 [import-pcolors "PvsC.png"] [import-pcolors "PvsP.png"] ask patch 120 160 [ set plabel-color black set plabel "GO, PIKACHU!" ]]
      	[Ifelse wildPokenum = 2 [import-pcolors "CvsP.png"] [import-pcolors "CvsC.png"] ask patch 130 160 [ set plabel-color black set plabel "GO, CHARMANDER!" ]]
]
  If currentPokemon = 2 and switched? = false [set currentPokemon 1
            Ifelse wildPokeNum = 2 [import-pcolors "PvsP.png"] [import-pcolors "PvsC.png"] ask patch 120 160 [ set plabel-color black set plabel "GO, PIKACHU!" ]
]
Experiencebar healthbars levelNumbers Pokenames
graybox
]  [ clear ask patch 170 160 [ set plabel-color black set plabel "YOU CANNOT SWITCH TO A FAINTED POKEMON"] Experiencebar healthbars levelNumbers Pokenames
graybox]]
  ]
end

to bMove1
  if battle? = true [
  clear
  if playerTurn? = true
  [ set playerTurn? false
    if currentPokemon = 1 [
    ifelse random 100 < 7
    [ set WildHealth (WildHealth - (0.8 * Poke1Attack * 2))  ; critical hit
      clear  Pokenames HealthBars levelNumbers
      ask patch 150 160 [set plabel-color black set plabel (word " CRITICAL HIT! YOU DID " (0.8 * Poke1Attack * 2)  " DAMAGE!" ) wait 1]
      ]
    [ set WildHealth (WildHealth - (0.8 * Poke1Attack))  ; normal hit
        clear Pokenames HealthBars levelNumbers
        ask patch 130 160 [set plabel-color black set plabel (word "YOU DID "  (0.8 * Poke1Attack)  " DAMAGE") wait 1
        ]
      ]
    ]
    if currentPokemon = 2 [
    ifelse random 100 < 7
    [ set WildHealth (WildHealth - (0.8 * Poke2Attack * 2))  ; critical hit
      clear  Pokenames HealthBars levelNumbers
      ask patch 150 160 [set plabel-color black set plabel (word " CRITICAL HIT! YOU DID " (0.8 * Poke2Attack * 2)  " DAMAGE!" ) wait 1]
      ]
    [ set WildHealth (WildHealth - (0.8 * Poke2Attack))  ; normal hit
        clear  Pokenames HealthBars levelNumbers
        ask patch 130 160 [set plabel-color black set plabel (word "YOU DID "  (0.8 * Poke2Attack)  " DAMAGE") wait 1
        ]
      ]
      ]
   ifelse WildHealth <= 0
            [  clear Pokenames HealthBars levelNumbers if wildBattle? = true [ask patch 150 160 [set plabel "YOU DEFEATED THE WILD POKEMON" ] wait 1.5]
                  if gymBattle? = true [ask patch 140 160 [set plabel "YOU DEFEATED BRAWLY!" ] wait 1.5]
            clear gainexperience Pokenames HealthBars levelNumbers
                  ask patch 130 160 [set plabel-color black set plabel (word "YOU GAINED " ((wildLevel - 2) * 10) " EXP")] wait 2
                  if gymBattle? = true [clear ask patch 140 160 [set plabel "YOU GOT A GYM BADGE!"] wait 2]
            set battle? false ToggleBattle ]
        [ wait 1.5 OpponentsTurn ]
    ]
   ]
end

to OpponentsTurn
  set opponentAttacked? false
  if currentPokemon = 1 and opponentAttacked? = false [
      ifelse random 100 < 7
    [ set Poke1Health (Poke1Health - (0.8 * WildAttack * 2))  ; critical hit
      clear     HealthBars levelNumbers Pokenames
      ask patch 150 160 [set plabel-color black set plabel (word "CRITICAL HIT! YOU TOOK " (0.8 * WildAttack * 2) " DAMAGE") ]
      ]
    [ set Poke1Health (Poke1Health - (0.8 * WildAttack))  ; normal hit
      clear     HealthBars levelNumbers Pokenames
       ask patch 130 160 [set plabel-color black set plabel (word "YOU TOOK " (0.8 * WildAttack)  " DAMAGE") ]
         ]
   ifelse Poke1Health <= 0
            [ifelse numPokemon = 2 [  ifelse Poke2Health > 0 [clear ask patch 140 160 [set plabel "YOUR POKEMON FAINTED"] wait 2 set playerTurn? true bswitch ]
            [clear ask patch 140 160 [set plabel-color black set plabel "YOU WERE DEFEATED" ] wait 2 ask patches [set plabel "" ] set battle? false ToggleBattle
          set spawning true setupPalletTown setupPoke1 Poke1Level setupPoke2 Poke2Level ask turtle 0 [set hidden? false]]
    ]
              [clear ask patch 140 160 [set plabel-color black set plabel "YOU WERE DEFEATED" ] wait 2 ask patches [set plabel "" ] set battle? false ToggleBattle
          set spawning true setupPalletTown setupPoke1 Poke1Level setupPoke2 Poke2Level clear ask turtle 0 [set hidden? false]]
    ]
        [ wait .5 set playerTurn? true]
  set opponentAttacked? true]
  if currentPokemon = 2 and opponentAttacked? = false [
      ifelse random 100 < 7
    [ set Poke2Health (Poke2Health - (0.8 * WildAttack * 2))  ; critical hit
      clear     HealthBars levelNumbers Pokenames
      ask patch 150 160 [set plabel-color black set plabel (word "CRITICAL HIT! YOU TOOK " (0.8 * WildAttack * 2) " DAMAGE") ]
      ]
    [ set Poke2Health (Poke2Health - (0.8 * WildAttack))  ; normal hit
      clear     HealthBars levelNumbers Pokenames
       ask patch 130 160 [set plabel-color black set plabel (word "YOU TOOK " (0.8 * WildAttack)  " DAMAGE") ]
         ]

    HealthBars levelNumbers Pokenames
   ifelse Poke2Health <= 0
    [ ifelse Poke1Health > 0 [clear ask patch 140 160 [set plabel "YOUR POKEMON FAINTED"] wait 2 set playerTurn? true bswitch ]
        [  clear ask patch 140 160 [set plabel-color black set plabel "YOU WERE DEFEATED" ] wait 2 ask patches [set plabel "" ] set battle? false ToggleBattle
          set spawning true setupPalletTown setupPoke1 Poke1Level setupPoke2 Poke2Level clear ask turtle 0 [set hidden? false]]
    ]
        [ wait .5 set playerTurn? true ]
  set opponentAttacked? true]
end


to bMove2
  if battle? = true [
  clear
  if playerTurn? = true
  [ if currentPokemon = 1 and poke1level >= 10 [ set playerTurn? false
    ifelse random 100 < 7
    [ set WildHealth (WildHealth - (Poke1Attack * 2))  ; critical hit
      clear  Pokenames HealthBars levelNumbers
      ask patch 150 160 [set plabel-color black set plabel (word " CRITICAL HIT! YOU DID " (Poke1Attack * 2)  " DAMAGE!" ) wait 1]
      ]
    [ set WildHealth (WildHealth - (Poke1Attack))  ; normal hit
        clear Pokenames HealthBars levelNumbers
        ask patch 130 160 [set plabel-color black set plabel (word "YOU DID "  (Poke1Attack)  " DAMAGE") wait 1
        ]
      ]
   ifelse WildHealth <= 0
        [  clear Pokenames HealthBars levelNumbers clear ask patch 150 160 [set plabel "YOU DEFEATED THE WILD POKEMON" ] wait 1.5
            clear gainexperience Pokenames HealthBars levelNumbers
            ask patch 130 160 [set plabel-color black set plabel (word "YOU GAINED " ((wildLevel - 2) * 10) " EXP") ] wait 3
           clear  set battle? false ToggleBattle ]
        [ wait 1 OpponentsTurn ]
    ]
    if currentPokemon = 2 and poke2level >= 10 [ set playerTurn? false
    ifelse random 100 < 7
    [ set WildHealth (WildHealth - (Poke2Attack * 2))  ; critical hit
      clear  Pokenames HealthBars levelNumbers
      ask patch 150 160 [set plabel-color black set plabel (word " CRITICAL HIT! YOU DID " (Poke2Attack * 2)  " DAMAGE!" ) wait 1]
      ]
    [ set WildHealth (WildHealth - (Poke2Attack))  ; normal hit
        clear  Pokenames HealthBars levelNumbers
        ask patch 130 160 [set plabel-color black set plabel (word "YOU DID "  (Poke2Attack)  " DAMAGE") wait 1
        ]
      ]
   ifelse WildHealth <= 0
            [  clear Pokenames HealthBars levelNumbers if wildBattle? = true [ask patch 150 160 [set plabel "YOU DEFEATED THE WILD POKEMON" ] wait 1.5]
                  if gymBattle? = true [ask patch 140 160 [set plabel "YOU DEFEATED BRAWLY!" ] wait 1.5]
            clear gainexperience Pokenames HealthBars levelNumbers
                  ask patch 130 160 [set plabel-color black set plabel (word "YOU GAINED " ((wildLevel - 2) * 10) " EXP")] wait 2
                  if gymBattle? = true [clear ask patch 140 160 [set plabel "YOU GOT A GYM BADGE!"] wait 2]
            set battle? false ToggleBattle ]
        [ wait 1.5 OpponentsTurn ]
    ]
   ]
  if playerTurn? = true and currentPokemon = 1 and  poke1level < 10  [ clear  Pokenames HealthBars levelNumbers ask patch 150 160
    [ set plabel-color black set plabel "YOU HAVE NOT LEARNED THIS MOVE" ]]
  if playerTurn? = true and currentPokemon = 2 and  poke2level < 10  [ clear  Pokenames HealthBars levelNumbers ask patch 150 160
    [ set plabel-color black set plabel "YOU HAVE NOT LEARNED THIS MOVE" ]]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
127
10
709
593
-1
-1
2.87
1
17
1
1
1
0
1
1
1
0
199
0
199
0
0
1
ticks
30.0

BUTTON
220
465
286
503
UP
moveUp
NIL
1
T
OBSERVER
NIL
W
NIL
NIL
1

BUTTON
284
502
352
541
RIGHT
moveRight
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

BUTTON
153
501
221
542
LEFT
moveLeft
NIL
1
T
OBSERVER
NIL
A
NIL
NIL
1

BUTTON
218
540
287
581
DOWN
moveDown
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
362
482
434
515
SWITCH
bSwitch
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
441
482
521
515
POKEBALL
bCatch
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
361
525
521
558
RUN
bRun
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
530
482
679
515
MOVE 1
bMove1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
530
524
680
560
MOVE 2
bMove2
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
252
48
585
98
POKEMON SIMULATOR
30
9.9
1

BUTTON
740
321
868
354
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
736
55
1100
274
FOR BEST PLAYER EXPERIENCE SET TICK SPEED MAXIMUM
25
0.0
1

@#$#@#$#@
Benson Ma and Peter Zhao   Pd. 9

## WHAT IS IT?

This is a simulator for the popular game Pokemon, where a player can train, catch, and battle Pokemon. Due to the complexity of adding Pokemon, there are only two species of Pokemon in this game: Pikachu and Charmander. The player starts out with a single Pokemon and builds up their own Pokemon arsenal by training and catching. Training Pokemon are necessary in order to defeat the gym leader at the end and earn a badge. The player can move around several maps, which consist of two towns and a route with grassy areas full of Pokemon.

## HOW IT WORKS

Our code for this simulator can be divided into two main parts: one regulating the movement of the player across the maps, and one regulating the battle scene between Pokemon. For the movement of the player, we used two global variables, horizontal and vertical, to know where the player is in relation to how much distance the player has traveled from their starting point. This allows us to create a fluid interface where the world moves to simulate player movement until the player reaches the borders of the map, where the turtle will start moving on its own. This also allows us to put in constraints for where the player can move, so that the player will not walk into the trees and houses. For the battle scene, we implemented a turn-based algorithm using a global variable called playerTurn? to make sure that the player cannot make two moves at once and that the wild Pokemon will make their move right after the player’s turn. 


## HOW TO USE IT

When you press setup, you will begin in Pallet Town, with a level 5 Pikachu. You can use the W, A, S, and D keys on your keyboard to move around the map. There are three maps in this world: Pallet Town, Route 1, and Sandgem Town. When you move into Route 1, there are patches of grass where you can find wild Pokemon. Here is where you can use the battle buttons on the bottom right part of the world to select what you want to do. You use Move 1 to use your basic attack, and Move 2, which unlocks at level 10, does even more damage. There is a run button, which allows you to escape from battle. Once you have lowered the wild Pokemon’s health low enough, you can catch it using the Pokeball button. You can only have up to two Pokemon at a time, and can switch between the two Pokemon using the switch button. Through battling and defeating other Pokemon, your Pokemon will gain experience and level up. The damage and health it has scales accordingly to its level. If your Pokemon are low on health, you can walk back to a town, which will restore your Pokemon back to full health. In Sandgem Town, there is a gym leader, Brawly, waiting for you. The objective of this game is to defeat him. He has a level 25 Pokemon, which has a large amount of health and attack. Since his Pokemon has such a high level, you must train your Pokemon in Route 1 and level them up in order to defeat him and earn your badge. Good luck!
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

back
false
4
Rectangle -16777216 true false 90 15 210 30
Rectangle -16777216 true false 225 45 240 75
Rectangle -16777216 true false 60 45 75 75
Rectangle -2674135 true false 90 30 105 45
Rectangle -2674135 true false 195 30 210 45
Rectangle -955883 true false 120 45 180 45
Rectangle -2674135 true false 90 45 210 60
Rectangle -2674135 true false 105 75 195 90
Rectangle -2674135 true false 90 60 210 75
Rectangle -2674135 true false 90 75 105 90
Rectangle -2674135 true false 195 75 210 90
Rectangle -16777216 true false 240 105 255 135
Rectangle -2674135 true false 60 75 60 120
Rectangle -2674135 true false 210 60 225 105
Rectangle -6459832 true false 75 90 135 105
Rectangle -6459832 true false 165 90 225 105
Rectangle -6459832 true false 135 90 165 105
Rectangle -6459832 true false 135 105 165 120
Rectangle -6459832 true false 180 105 195 120
Rectangle -6459832 true false 105 105 120 120
Rectangle -6459832 true false 120 105 135 120
Rectangle -6459832 true false 165 105 180 120
Rectangle -6459832 true false 90 105 105 120
Rectangle -6459832 true false 195 105 210 120
Rectangle -2674135 true false 105 30 195 45
Rectangle -2674135 true false 75 60 90 90
Rectangle -16777216 true false 75 30 90 60
Rectangle -16777216 true false 210 30 225 60
Rectangle -16777216 true false 60 60 75 105
Rectangle -16777216 true false 225 60 240 105
Rectangle -6459832 true false 75 105 90 150
Rectangle -6459832 true false 210 105 225 150
Rectangle -6459832 true false 90 120 105 135
Rectangle -6459832 true false 105 135 195 150
Rectangle -6459832 true false 195 120 210 135
Rectangle -6459832 true false 105 120 195 135
Rectangle -6459832 true false 105 150 120 165
Rectangle -16777216 true false 120 150 135 165
Rectangle -6459832 true false 180 150 195 165
Rectangle -6459832 true false 120 150 135 165
Rectangle -6459832 true false 165 150 180 165
Rectangle -6459832 true false 135 150 165 180
Rectangle -6459832 true false 120 165 135 180
Rectangle -6459832 true false 165 165 180 180
Rectangle -13345367 true false 105 180 120 195
Rectangle -6459832 true false 180 180 195 195
Rectangle -16777216 true false 75 120 90 135
Rectangle -16777216 true false 210 120 225 135
Rectangle -1184463 true true 225 105 240 135
Rectangle -1184463 true true 60 105 75 135
Rectangle -1184463 true true 195 150 210 150
Rectangle -6459832 true false 195 135 210 180
Rectangle -6459832 true false 90 135 105 180
Rectangle -1184463 true true 180 165 195 180
Rectangle -1184463 true true 105 165 120 180
Rectangle -955883 true false 120 180 180 195
Rectangle -6459832 true false 210 150 225 165
Rectangle -6459832 true false 75 150 90 165
Rectangle -2674135 true false 75 165 90 180
Rectangle -13345367 true false 90 180 105 195
Rectangle -6459832 true false 195 180 210 195
Rectangle -955883 true false 180 195 195 225
Rectangle -955883 true false 105 195 120 225
Rectangle -955883 true false 120 210 135 225
Rectangle -955883 true false 165 210 180 225
Rectangle -955883 true false 135 210 165 225
Rectangle -955883 true false 120 195 180 210
Rectangle -955883 true false 135 225 165 240
Rectangle -955883 true false 120 225 135 240
Rectangle -955883 true false 165 225 180 240
Rectangle -13345367 true false 195 195 210 225
Rectangle -6459832 true false 210 165 225 180
Rectangle -13345367 true false 90 195 105 225
Rectangle -13345367 true false 75 180 90 210
Rectangle -13345367 true false 210 180 225 210
Rectangle -1 true false 225 195 240 210
Rectangle -1 true false 60 195 75 210
Rectangle -16777216 true false 60 180 75 195
Rectangle -16777216 true false 225 180 240 195
Rectangle -16777216 true false 60 135 75 165
Rectangle -16777216 true false 225 135 240 165
Rectangle -13345367 true false 105 240 120 255
Rectangle -13345367 true false 180 240 195 255
Rectangle -13791810 true false 105 255 135 270
Rectangle -13791810 true false 165 255 195 270
Rectangle -13345367 true false 180 270 210 285
Rectangle -13345367 true false 90 270 120 285
Rectangle -16777216 true false 120 240 180 255
Rectangle -16777216 true false 135 255 165 270
Rectangle -16777216 true false 120 270 135 285
Rectangle -16777216 true false 165 270 180 285
Rectangle -13345367 true false 210 240 225 255
Rectangle -13345367 true false 75 240 90 255
Rectangle -13791810 true false 90 240 105 255
Rectangle -13791810 true false 195 240 210 255
Rectangle -1184463 true true 210 210 240 225
Rectangle -1184463 true true 60 210 90 225
Rectangle -6459832 true false 45 195 60 225
Rectangle -6459832 true false 60 225 75 240
Rectangle -6459832 true false 240 195 255 225
Rectangle -6459832 true false 225 225 240 240
Rectangle -16777216 true false 120 270 135 285
Rectangle -16777216 true false 90 285 120 300
Rectangle -16777216 true false 180 285 210 300
Rectangle -16777216 true false 195 255 225 270
Rectangle -16777216 true false 210 270 225 285
Rectangle -16777216 true false 75 255 105 270
Rectangle -16777216 true false 75 270 90 285
Rectangle -16777216 true false 240 105 255 135
Rectangle -16777216 true false 45 105 60 135
Rectangle -16777216 true false 75 225 120 240
Rectangle -6459832 true false 75 165 225 180
Rectangle -6459832 true false 90 150 210 165
Rectangle -6459832 true false 75 165 225 180
Rectangle -6459832 true false 90 165 210 180
Rectangle -955883 true false 105 165 120 180
Rectangle -955883 true false 180 165 195 180
Rectangle -955883 true false 75 150 105 165
Rectangle -955883 true false 195 150 225 165
Rectangle -2674135 true false 135 90 165 105
Rectangle -13345367 true false 75 165 105 180
Rectangle -13345367 true false 195 165 225 180
Rectangle -13345367 true false 180 180 210 195
Rectangle -13345367 true false 120 165 180 180
Rectangle -6459832 true false 105 150 195 165

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

brawly
false
4
Rectangle -16777216 true false 225 45 240 75
Rectangle -16777216 true false 60 45 75 75
Rectangle -955883 true false 120 45 180 45
Rectangle -2674135 true false 195 75 210 90
Rectangle -16777216 true false 240 105 255 135
Rectangle -2674135 true false 60 75 60 120
Rectangle -2674135 true false 75 90 135 105
Rectangle -2674135 true false 165 90 225 105
Rectangle -1 true false 135 90 165 105
Rectangle -2674135 true false 135 105 165 120
Rectangle -2674135 true false 180 105 195 120
Rectangle -2674135 true false 105 105 120 120
Rectangle -7500403 true false 120 105 135 120
Rectangle -7500403 true false 165 105 180 120
Rectangle -7500403 true false 90 105 105 120
Rectangle -7500403 true false 195 105 210 120
Rectangle -6459832 true false 75 105 90 150
Rectangle -6459832 true false 210 105 225 150
Rectangle -13345367 true false 90 120 105 135
Rectangle -13345367 true false 105 135 195 150
Rectangle -13345367 true false 195 120 210 135
Rectangle -1 true false 105 120 195 135
Rectangle -1 true false 105 150 120 165
Rectangle -16777216 true false 120 150 135 165
Rectangle -1 true false 180 150 195 165
Rectangle -16777216 true false 120 150 135 165
Rectangle -16777216 true false 165 150 180 165
Rectangle -1 true false 135 150 165 180
Rectangle -6459832 true false 120 165 135 180
Rectangle -16777216 true false 165 165 180 180
Rectangle -6459832 true false 105 180 120 195
Rectangle -6459832 true false 180 180 195 195
Rectangle -2674135 true false 75 120 90 135
Rectangle -2674135 true false 210 120 225 135
Rectangle -1184463 true true 225 105 240 135
Rectangle -1184463 true true 60 105 75 135
Rectangle -1184463 true true 195 150 210 150
Rectangle -1184463 true true 195 135 210 180
Rectangle -1184463 true true 90 135 105 180
Rectangle -1184463 true true 180 165 195 180
Rectangle -1184463 true true 105 165 120 180
Rectangle -1184463 true true 120 180 180 195
Rectangle -1184463 true true 210 150 225 165
Rectangle -1184463 true true 75 150 90 165
Rectangle -6459832 true false 75 165 90 180
Rectangle -6459832 true false 90 180 105 195
Rectangle -6459832 true false 195 180 210 195
Rectangle -2674135 true false 180 195 195 240
Rectangle -2674135 true false 105 195 120 240
Rectangle -2674135 true false 120 210 135 225
Rectangle -2674135 true false 165 210 180 225
Rectangle -7500403 true false 135 210 165 225
Rectangle -16777216 true false 120 195 180 210
Rectangle -1 true false 135 225 165 240
Rectangle -955883 true false 120 225 135 240
Rectangle -955883 true false 165 225 180 240
Rectangle -13345367 true false 195 195 210 225
Rectangle -6459832 true false 210 165 225 180
Rectangle -13345367 true false 90 195 105 225
Rectangle -13345367 true false 75 180 90 210
Rectangle -13345367 true false 210 180 225 210
Rectangle -1 true false 225 195 240 210
Rectangle -1 true false 60 195 75 210
Rectangle -16777216 true false 60 180 75 195
Rectangle -16777216 true false 225 180 240 195
Rectangle -16777216 true false 60 135 75 165
Rectangle -16777216 true false 225 135 240 165
Rectangle -13345367 true false 105 240 120 255
Rectangle -13345367 true false 180 240 195 255
Rectangle -13791810 true false 105 255 135 270
Rectangle -13791810 true false 165 255 195 270
Rectangle -13345367 true false 180 270 210 285
Rectangle -13345367 true false 90 270 120 285
Rectangle -16777216 true false 120 240 180 255
Rectangle -16777216 true false 135 255 165 270
Rectangle -16777216 true false 120 270 135 285
Rectangle -16777216 true false 165 270 180 285
Rectangle -13345367 true false 210 240 225 255
Rectangle -13345367 true false 75 240 90 255
Rectangle -13791810 true false 90 240 105 255
Rectangle -13791810 true false 195 240 210 255
Rectangle -1184463 true true 210 210 240 225
Rectangle -1184463 true true 60 210 90 225
Rectangle -6459832 true false 45 195 60 225
Rectangle -6459832 true false 60 225 75 240
Rectangle -6459832 true false 240 195 255 225
Rectangle -6459832 true false 225 225 240 240
Rectangle -16777216 true false 120 270 135 285
Rectangle -16777216 true false 90 285 120 300
Rectangle -16777216 true false 180 285 210 300
Rectangle -16777216 true false 195 255 225 270
Rectangle -16777216 true false 210 270 225 285
Rectangle -16777216 true false 75 255 105 270
Rectangle -16777216 true false 75 270 90 285
Rectangle -16777216 true false 240 105 255 135
Rectangle -16777216 true false 45 105 60 135
Polygon -11221820 true false 75 105 60 45 105 60 120 15 150 60 180 15 195 60 225 45 240 45 225 105 75 105 75 105
Rectangle -16777216 true false 75 105 225 120
Rectangle -16777216 true false 120 165 135 180
Polygon -11221820 true false 75 105 45 15 105 60 120 0 150 45 180 0 195 45 240 15 225 105 75 105
Polygon -16777216 true false 75 105 60 105 30 0 105 45 105 45 120 0 150 30 180 0 195 30 195 30 195 30 195 45 210 30 240 15 240 45 240 45 255 45 240 105 225 105 240 45 240 45 240 15 195 45 180 0 150 45 120 0 105 60 45 15 75 105 60 105
Rectangle -955883 true false 90 105 90 105
Rectangle -955883 true false 90 120 210 165
Polygon -955883 true false 150 150
Polygon -1 true false 150 150 150 120 141 120 143 151 159 148 159 121 147 119
Polygon -1 true false 157 154 158 118 140 118 141 155 159 151
Polygon -1 true false 161 152
Polygon -1 true false 144 41
Polygon -16777216 true false 199 32 187 0 179 1 196 41 240 15 235 44 247 48 249 7 200 30
Polygon -16777216 true false 105 45
Polygon -16777216 true false 102 46 113 0 120 2 104 50
Polygon -16777216 true false 149 31 128 0 117 0
Polygon -16777216 true false 157 25 172 1 187 1 173 1
Polygon -1 true false 141 151 143 175 158 169 158 141 142 153 143 170 160 164 155 142 142 151 142 169 157 149
Rectangle -1 true false 142 125 159 175
Rectangle -955883 true false 135 120 165 135
Rectangle -2674135 true false 75 105 225 120
Rectangle -16777216 true false 45 195 45 225

brawly2
false
4
Polygon -16777216 true false 67 104 23 55 74 65 47 11 111 41 105 0 115 3 146 36 164 2 169 1 180 43 220 2 215 54 256 35 231 105 65 105
Polygon -13791810 true false 76 105 40 64 84 74 57 21 117 49 111 4 147 45 167 5 178 52 214 13 211 63 248 45 225 105 75 105
Rectangle -955883 true false 120 45 180 45
Rectangle -955883 true false 105 75 195 90
Rectangle -16777216 true false 240 105 255 135
Rectangle -2674135 true false 60 75 60 120
Rectangle -1 true false 135 90 165 105
Rectangle -1 true false 135 105 165 120
Rectangle -2674135 true false 180 105 195 120
Rectangle -2674135 true false 105 105 120 120
Rectangle -7500403 true false 120 105 135 120
Rectangle -7500403 true false 165 105 180 120
Rectangle -7500403 true false 90 105 105 120
Rectangle -7500403 true false 195 105 210 120
Rectangle -6459832 true false 75 105 90 150
Rectangle -6459832 true false 210 105 225 150
Rectangle -13345367 true false 90 120 105 135
Rectangle -1 true false 105 135 195 150
Rectangle -13345367 true false 195 120 210 135
Rectangle -1 true false 105 120 195 135
Rectangle -1 true false 105 150 120 165
Rectangle -16777216 true false 120 150 135 165
Rectangle -1 true false 180 150 195 165
Rectangle -16777216 true false 120 150 135 165
Rectangle -16777216 true false 165 150 180 165
Rectangle -1 true false 135 150 165 180
Rectangle -6459832 true false 120 165 135 180
Rectangle -6459832 true false 165 165 180 180
Rectangle -6459832 true false 105 180 120 195
Rectangle -6459832 true false 180 180 195 195
Rectangle -16777216 true false 75 120 90 135
Rectangle -16777216 true false 210 120 225 135
Rectangle -1184463 true true 225 105 240 135
Rectangle -1184463 true true 60 105 75 135
Rectangle -1184463 true true 195 150 210 150
Rectangle -1184463 true true 195 135 210 180
Rectangle -1184463 true true 90 135 105 180
Rectangle -1184463 true true 180 165 195 180
Rectangle -1184463 true true 105 165 120 180
Rectangle -1184463 true true 120 180 180 195
Rectangle -1184463 true true 210 150 225 165
Rectangle -1184463 true true 75 150 90 165
Rectangle -6459832 true false 75 165 90 180
Rectangle -6459832 true false 90 180 105 195
Rectangle -6459832 true false 195 180 210 195
Rectangle -2674135 true false 180 195 195 240
Rectangle -2674135 true false 105 195 120 240
Rectangle -2674135 true false 120 210 135 225
Rectangle -2674135 true false 165 210 180 225
Rectangle -7500403 true false 135 210 165 225
Rectangle -16777216 true false 120 195 180 210
Rectangle -1 true false 135 225 165 240
Rectangle -955883 true false 120 225 135 240
Rectangle -955883 true false 165 225 180 240
Rectangle -13345367 true false 195 195 210 225
Rectangle -6459832 true false 210 165 225 180
Rectangle -13345367 true false 90 195 105 225
Rectangle -13345367 true false 75 180 90 210
Rectangle -13345367 true false 210 180 225 210
Rectangle -1 true false 225 195 240 210
Rectangle -1 true false 60 195 75 210
Rectangle -16777216 true false 60 180 75 195
Rectangle -16777216 true false 225 180 240 195
Rectangle -16777216 true false 60 135 75 165
Rectangle -16777216 true false 225 135 240 165
Rectangle -13345367 true false 105 240 120 255
Rectangle -13345367 true false 180 240 195 255
Rectangle -13791810 true false 105 255 135 270
Rectangle -13791810 true false 165 255 195 270
Rectangle -13345367 true false 180 270 210 285
Rectangle -13345367 true false 90 270 120 285
Rectangle -16777216 true false 120 240 180 255
Rectangle -16777216 true false 135 255 165 270
Rectangle -16777216 true false 120 270 135 285
Rectangle -16777216 true false 165 270 180 285
Rectangle -13345367 true false 210 240 225 255
Rectangle -13345367 true false 75 240 90 255
Rectangle -13791810 true false 90 240 105 255
Rectangle -13791810 true false 195 240 210 255
Rectangle -1184463 true true 210 210 240 225
Rectangle -1184463 true true 60 210 90 225
Rectangle -6459832 true false 45 195 60 225
Rectangle -6459832 true false 60 225 75 240
Rectangle -6459832 true false 240 195 255 225
Rectangle -6459832 true false 225 225 240 240
Rectangle -16777216 true false 120 270 135 285
Rectangle -16777216 true false 90 285 120 300
Rectangle -16777216 true false 180 285 210 300
Rectangle -16777216 true false 195 255 225 270
Rectangle -16777216 true false 210 270 225 285
Rectangle -16777216 true false 75 255 105 270
Rectangle -16777216 true false 75 270 90 285
Rectangle -16777216 true false 240 105 255 135
Rectangle -16777216 true false 45 105 60 135
Rectangle -955883 true false 105 60 105 75
Rectangle -955883 true false 105 90 135 120
Rectangle -955883 true false 165 90 195 120
Rectangle -955883 true false 125 86 143 119
Rectangle -955883 true false 158 89 167 119
Rectangle -16777216 true false 106 65 196 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

front
false
4
Rectangle -16777216 true false 90 15 210 30
Rectangle -16777216 true false 225 45 240 75
Rectangle -16777216 true false 60 45 75 75
Rectangle -2674135 true false 90 30 105 45
Rectangle -2674135 true false 195 30 210 45
Rectangle -955883 true false 120 45 180 45
Rectangle -955883 true false 90 45 210 60
Rectangle -955883 true false 105 75 195 90
Rectangle -955883 true false 90 60 210 75
Rectangle -2674135 true false 90 75 105 90
Rectangle -2674135 true false 195 75 210 90
Rectangle -16777216 true false 240 105 255 135
Rectangle -2674135 true false 60 75 60 120
Rectangle -2674135 true false 210 60 225 105
Rectangle -2674135 true false 75 90 135 105
Rectangle -2674135 true false 165 90 225 105
Rectangle -1 true false 135 90 165 105
Rectangle -2674135 true false 135 105 165 120
Rectangle -2674135 true false 180 105 195 120
Rectangle -2674135 true false 105 105 120 120
Rectangle -7500403 true false 120 105 135 120
Rectangle -7500403 true false 165 105 180 120
Rectangle -7500403 true false 90 105 105 120
Rectangle -7500403 true false 195 105 210 120
Rectangle -955883 true false 105 30 195 45
Rectangle -2674135 true false 75 60 90 90
Rectangle -16777216 true false 75 30 90 60
Rectangle -16777216 true false 210 30 225 60
Rectangle -16777216 true false 60 60 75 105
Rectangle -16777216 true false 225 60 240 105
Rectangle -6459832 true false 75 105 90 150
Rectangle -6459832 true false 210 105 225 150
Rectangle -13345367 true false 90 120 105 135
Rectangle -13345367 true false 105 135 195 150
Rectangle -13345367 true false 195 120 210 135
Rectangle -1 true false 105 120 195 135
Rectangle -1 true false 105 150 120 165
Rectangle -16777216 true false 120 150 135 165
Rectangle -1 true false 180 150 195 165
Rectangle -16777216 true false 120 150 135 165
Rectangle -16777216 true false 165 150 180 165
Rectangle -1 true false 135 150 165 180
Rectangle -6459832 true false 120 165 135 180
Rectangle -6459832 true false 165 165 180 180
Rectangle -6459832 true false 105 180 120 195
Rectangle -6459832 true false 180 180 195 195
Rectangle -16777216 true false 75 120 90 135
Rectangle -16777216 true false 210 120 225 135
Rectangle -1184463 true true 225 105 240 135
Rectangle -1184463 true true 60 105 75 135
Rectangle -1184463 true true 195 150 210 150
Rectangle -1184463 true true 195 135 210 180
Rectangle -1184463 true true 90 135 105 180
Rectangle -1184463 true true 180 165 195 180
Rectangle -1184463 true true 105 165 120 180
Rectangle -1184463 true true 120 180 180 195
Rectangle -1184463 true true 210 150 225 165
Rectangle -1184463 true true 75 150 90 165
Rectangle -6459832 true false 75 165 90 180
Rectangle -6459832 true false 90 180 105 195
Rectangle -6459832 true false 195 180 210 195
Rectangle -2674135 true false 180 195 195 240
Rectangle -2674135 true false 105 195 120 240
Rectangle -2674135 true false 120 210 135 225
Rectangle -2674135 true false 165 210 180 225
Rectangle -7500403 true false 135 210 165 225
Rectangle -16777216 true false 120 195 180 210
Rectangle -1 true false 135 225 165 240
Rectangle -955883 true false 120 225 135 240
Rectangle -955883 true false 165 225 180 240
Rectangle -13345367 true false 195 195 210 225
Rectangle -6459832 true false 210 165 225 180
Rectangle -13345367 true false 90 195 105 225
Rectangle -13345367 true false 75 180 90 210
Rectangle -13345367 true false 210 180 225 210
Rectangle -1 true false 225 195 240 210
Rectangle -1 true false 60 195 75 210
Rectangle -16777216 true false 60 180 75 195
Rectangle -16777216 true false 225 180 240 195
Rectangle -16777216 true false 60 135 75 165
Rectangle -16777216 true false 225 135 240 165
Rectangle -13345367 true false 105 240 120 255
Rectangle -13345367 true false 180 240 195 255
Rectangle -13791810 true false 105 255 135 270
Rectangle -13791810 true false 165 255 195 270
Rectangle -13345367 true false 180 270 210 285
Rectangle -13345367 true false 90 270 120 285
Rectangle -16777216 true false 120 240 180 255
Rectangle -16777216 true false 135 255 165 270
Rectangle -16777216 true false 120 270 135 285
Rectangle -16777216 true false 165 270 180 285
Rectangle -13345367 true false 210 240 225 255
Rectangle -13345367 true false 75 240 90 255
Rectangle -13791810 true false 90 240 105 255
Rectangle -13791810 true false 195 240 210 255
Rectangle -1184463 true true 210 210 240 225
Rectangle -1184463 true true 60 210 90 225
Rectangle -6459832 true false 45 195 60 225
Rectangle -6459832 true false 60 225 75 240
Rectangle -6459832 true false 240 195 255 225
Rectangle -6459832 true false 225 225 240 240
Rectangle -16777216 true false 120 270 135 285
Rectangle -16777216 true false 90 285 120 300
Rectangle -16777216 true false 180 285 210 300
Rectangle -16777216 true false 195 255 225 270
Rectangle -16777216 true false 210 270 225 285
Rectangle -16777216 true false 75 255 105 270
Rectangle -16777216 true false 75 270 90 285
Rectangle -16777216 true false 240 105 255 135
Rectangle -16777216 true false 45 105 60 135

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

leftside
false
15
Rectangle -16777216 true false 90 30 210 45
Rectangle -2674135 true false 75 45 195 60
Rectangle -2674135 true false 105 60 210 75
Rectangle -2674135 true false 120 75 195 90
Rectangle -2674135 true false 90 90 135 105
Rectangle -7500403 true false 60 75 120 90
Rectangle -7500403 true false 90 60 105 75
Rectangle -16777216 true false 75 45 90 75
Rectangle -16777216 true false 60 60 75 75
Rectangle -16777216 true false 210 45 225 90
Rectangle -16777216 true false 195 75 240 90
Rectangle -16777216 true false 135 90 240 105
Rectangle -16777216 true false 150 105 165 135
Rectangle -16777216 true false 165 105 240 120
Rectangle -16777216 true false 195 120 210 150
Rectangle -16777216 true false 210 120 225 135
Rectangle -16777216 true false 105 105 120 135
Rectangle -1 true true 120 105 150 135
Rectangle -16777216 true false 105 105 120 135
Rectangle -1 true true 90 105 105 135
Rectangle -16777216 true false 75 90 90 150
Rectangle -16777216 true false 60 90 75 105
Rectangle -16777216 true false 45 75 60 90
Rectangle -1184463 true false 165 135 195 135
Rectangle -1 true true 90 135 195 150
Rectangle -1 true true 165 120 195 135
Rectangle -16777216 true false 165 150 195 180
Rectangle -16777216 true false 90 150 105 165
Rectangle -1 true true 105 150 165 165
Rectangle -16777216 true false 105 165 165 180
Rectangle -16777216 true false 75 180 165 195
Rectangle -16777216 true false 105 195 120 210
Rectangle -16777216 true false 150 195 165 210
Rectangle -16777216 true false 120 210 195 225
Rectangle -16777216 true false 60 195 75 225
Rectangle -16777216 true false 90 225 120 240
Rectangle -16777216 true false 75 210 90 225
Rectangle -16777216 true false 225 195 240 225
Rectangle -16777216 true false 195 225 225 240
Rectangle -16777216 true false 195 180 210 210
Rectangle -16777216 true false 195 180 225 195
Rectangle -16777216 true false 210 150 225 180
Rectangle -13791810 true false 195 150 210 180
Rectangle -1 true true 120 195 150 210
Rectangle -1 true true 90 210 120 225
Rectangle -1 true true 195 210 225 225
Rectangle -1 true true 75 195 105 210
Rectangle -1 true true 165 180 195 210
Rectangle -1 true true 210 195 225 210

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

rightside
false
15
Rectangle -16777216 true false 90 30 210 45
Rectangle -2674135 true false 105 45 225 60
Rectangle -2674135 true false 90 60 195 75
Rectangle -2674135 true false 105 75 180 90
Rectangle -2674135 true false 165 90 210 105
Rectangle -7500403 true false 180 75 240 90
Rectangle -7500403 true false 195 60 210 75
Rectangle -16777216 true false 210 45 225 75
Rectangle -16777216 true false 225 60 240 75
Rectangle -16777216 true false 75 45 90 90
Rectangle -16777216 true false 60 75 105 90
Rectangle -16777216 true false 60 90 165 105
Rectangle -16777216 true false 135 105 150 135
Rectangle -16777216 true false 60 105 135 120
Rectangle -16777216 true false 90 120 105 150
Rectangle -16777216 true false 75 120 90 135
Rectangle -16777216 true false 180 105 195 135
Rectangle -1 true true 150 105 180 135
Rectangle -16777216 true false 180 105 195 135
Rectangle -1 true true 195 105 210 135
Rectangle -16777216 true false 210 90 225 150
Rectangle -16777216 true false 225 90 240 105
Rectangle -16777216 true false 240 75 255 90
Rectangle -1184463 true false 105 135 135 135
Rectangle -1 true true 105 135 210 150
Rectangle -1 true true 105 120 135 135
Rectangle -16777216 true false 105 150 135 180
Rectangle -16777216 true false 195 150 210 165
Rectangle -1 true true 135 150 195 165
Rectangle -16777216 true false 135 165 195 180
Rectangle -16777216 true false 135 180 225 195
Rectangle -16777216 true false 180 195 195 210
Rectangle -16777216 true false 135 195 150 210
Rectangle -16777216 true false 105 210 180 225
Rectangle -16777216 true false 225 195 240 225
Rectangle -16777216 true false 180 225 210 240
Rectangle -16777216 true false 210 210 225 225
Rectangle -16777216 true false 60 195 75 225
Rectangle -16777216 true false 75 225 105 240
Rectangle -16777216 true false 90 180 105 210
Rectangle -16777216 true false 75 180 105 195
Rectangle -16777216 true false 75 150 90 180
Rectangle -13791810 true false 90 150 105 180
Rectangle -1 true true 150 195 180 210
Rectangle -1 true true 180 210 210 225
Rectangle -1 true true 75 210 105 225
Rectangle -1 true true 195 195 225 210
Rectangle -1 true true 105 180 135 210
Rectangle -1 true true 75 195 90 210

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
