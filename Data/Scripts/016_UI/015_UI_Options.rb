#===============================================================================
#
#===============================================================================
class PokemonSystem
  attr_accessor :textspeed
  attr_accessor :battlescene
  attr_accessor :battlestyle
  attr_accessor :frame
  attr_accessor :textskin
  attr_accessor :screensize
  attr_accessor :language
  attr_accessor :runstyle
  attr_accessor :bgmvolume
  attr_accessor :sevolume
  attr_accessor :textinput
  attr_accessor :quicksurf
  attr_accessor :battle_type
  attr_accessor :force_double_wild
  attr_accessor :download_sprites
  #KurayX
  attr_accessor :shiny_icons_kuray
  attr_accessor :kuray_no_evo
  attr_accessor :shinyfusedye
  attr_accessor :kurayfusepreview
  attr_accessor :kuraylevelcap
  attr_accessor :kuraynormalshiny
  attr_accessor :kurayqol
  attr_accessor :kuraygambleodds
  attr_accessor :kurayshinyanim
  attr_accessor :kurayfonts
  attr_accessor :shenanigans
  attr_accessor :kuraybigicons

  def initialize
    @textspeed = 1 # Text speed (0=slow, 1=normal, 2=fast)
    @battlescene = 0 # Battle effects (animations) (0=on, 1=off)
    @battlestyle = 0 # Battle style (0=switch, 1=set)
    @frame = 0 # Default window frame (see also Settings::MENU_WINDOWSKINS)
    @textskin = 0 # Speech frame
    @screensize = (Settings::SCREEN_SCALE * 2).floor - 1 # 0=half size, 1=full size, 2=full-and-a-half size, 3=double size
    @language = 0 # Language (see also Settings::LANGUAGES in script PokemonSystem)
    @runstyle = 0 # Default movement speed (0=walk, 1=run)
    @bgmvolume = 100 # Volume of background music and ME
    @sevolume = 100 # Volume of sound effects
    @textinput = 1 # Text input mode (0=cursor, 1=keyboard)
    @quicksurf = 0
    @battle_type = 0
    @force_double_wild = 0
    #KurayX
    @shiny_icons_kuray = 0
    @kurayshinyanim = 0
    @kuray_no_evo = 0
    @shinyfusedye = 0
    @download_sprites = 0
    @kurayfusepreview = 0
    @kuraylevelcap = 0
    @kurayfonts = 0
    @kuraynormalshiny = 0
    @kuraygambleodds = 100
    @kurayqol = 1
    @shenanigans = 0
    @kuraybigicons = 0

  end
end

#===============================================================================
#
#===============================================================================
module PropertyMixin
  def get
    (@getProc) ? @getProc.call : nil
  end

  def set(value)
    @setProc.call(value) if @setProc
  end
end

class Option
  attr_reader :description

  def initialize(description)
    @description = description
  end
end

#===============================================================================
#
#===============================================================================
class EnumOption < Option
  include PropertyMixin
  attr_reader :values
  attr_reader :name

  def initialize(name, options, getProc, setProc, description = "")
    super(description)
    @name = name
    @values = options
    @getProc = getProc
    @setProc = setProc
  end

  def next(current)
    index = current + 1
    index = @values.length - 1 if index > @values.length - 1
    return index
  end

  def prev(current)
    index = current - 1
    index = 0 if index < 0
    return index
  end
end

#===============================================================================
#
#===============================================================================
class EnumOption2
  include PropertyMixin
  attr_reader :values
  attr_reader :name

  def initialize(name, options, getProc, setProc)
    @name = name
    @values = options
    @getProc = getProc
    @setProc = setProc
  end

  def next(current)
    index = current + 1
    index = @values.length - 1 if index > @values.length - 1
    return index
  end

  def prev(current)
    index = current - 1
    index = 0 if index < 0
    return index
  end
end

#===============================================================================
#
#===============================================================================
class NumberOption
  include PropertyMixin
  attr_reader :name
  attr_reader :optstart
  attr_reader :optend

  def initialize(name, optstart, optend, getProc, setProc)
    @name = name
    @optstart = optstart
    @optend = optend
    @getProc = getProc
    @setProc = setProc
  end

  def next(current)
    index = current + @optstart
    index += 1
    index = @optstart if index > @optend
    return index - @optstart
  end

  def prev(current)
    index = current + @optstart
    index -= 1
    index = @optend if index < @optstart
    return index - @optstart
  end
end

#===============================================================================
#
#===============================================================================
class SliderOption < Option
  include PropertyMixin
  attr_reader :name
  attr_reader :optstart
  attr_reader :optend

  def initialize(name, optstart, optend, optinterval, getProc, setProc, description = "")
    super(description)
    @name = name
    @optstart = optstart
    @optend = optend
    @optinterval = optinterval
    @getProc = getProc
    @setProc = setProc
  end

  def next(current)
    index = current + @optstart
    index += @optinterval
    index = @optend if index > @optend
    return index - @optstart
  end

  def prev(current)
    index = current + @optstart
    index -= @optinterval
    index = @optstart if index < @optstart
    return index - @optstart
  end
end

#===============================================================================
# Main options list
#===============================================================================
class Window_PokemonOption < Window_DrawableCommand
  attr_reader :mustUpdateOptions
  attr_reader :mustUpdateDescription
  attr_reader :selected_position

  def initialize(options, x, y, width, height)
    @previous_Index = 0
    @options = options
    @nameBaseColor = Color.new(24 * 8, 15 * 8, 0)
    @nameShadowColor = Color.new(31 * 8, 22 * 8, 10 * 8)
    @selBaseColor = Color.new(31 * 8, 6 * 8, 3 * 8)
    @selShadowColor = Color.new(31 * 8, 17 * 8, 16 * 8)
    @optvalues = []
    @mustUpdateOptions = false
    @mustUpdateDescription = false
    @selected_position = 0
    for i in 0...@options.length
      @optvalues[i] = 0
    end
    super(x, y, width, height)
  end

  def changedPosition
    @mustUpdateDescription = true
    super
  end

  def descriptionUpdated
    @mustUpdateDescription = false
  end

  def nameBaseColor=(value)
    @nameBaseColor = value
  end

  def nameShadowColor=(value)
    @nameShadowColor = value
  end

  def [](i)
    return @optvalues[i]
  end

  def []=(i, value)
    @optvalues[i] = value
    refresh
  end

  def setValueNoRefresh(i, value)
    @optvalues[i] = value
  end

  def itemCount
    return @options.length + 1
  end

  def dont_draw_item(index)
    return false
  end

  def drawItem(index, _count, rect)
    return if dont_draw_item(index)
    rect = drawCursor(index, rect)
    optionname = (index == @options.length) ? _INTL("Confirm") : @options[index].name
    optionwidth = rect.width * 9 / 20
    pbDrawShadowText(self.contents, rect.x, rect.y, optionwidth, rect.height, optionname,
                     @nameBaseColor, @nameShadowColor)
    return if index == @options.length
    if @options[index].is_a?(EnumOption)
      if @options[index].values.length > 1
        totalwidth = 0
        for value in @options[index].values
          totalwidth += self.contents.text_size(value).width
        end
        spacing = (optionwidth - totalwidth) / (@options[index].values.length - 1)
        spacing = 0 if spacing < 0
        xpos = optionwidth + rect.x
        ivalue = 0
        for value in @options[index].values
          pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                           (ivalue == self[index]) ? @selBaseColor : self.baseColor,
                           (ivalue == self[index]) ? @selShadowColor : self.shadowColor
          )
          xpos += self.contents.text_size(value).width
          xpos += spacing
          ivalue += 1
        end
      else
        pbDrawShadowText(self.contents, rect.x + optionwidth, rect.y, optionwidth, rect.height,
                         optionname, self.baseColor, self.shadowColor)
      end
    elsif @options[index].is_a?(NumberOption)
      value = _INTL("Type {1}/{2}", @options[index].optstart + self[index],
                    @options[index].optend - @options[index].optstart + 1)
      xpos = optionwidth + rect.x
      pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                       @selBaseColor, @selShadowColor)
    elsif @options[index].is_a?(SliderOption)
      value = sprintf(" %d", @options[index].optend)
      sliderlength = optionwidth - self.contents.text_size(value).width
      xpos = optionwidth + rect.x
      self.contents.fill_rect(xpos, rect.y - 2 + rect.height / 2,
                              optionwidth - self.contents.text_size(value).width, 4, self.baseColor)
      self.contents.fill_rect(
        xpos + (sliderlength - 8) * (@options[index].optstart + self[index]) / @options[index].optend,
        rect.y - 8 + rect.height / 2,
        8, 16, @selBaseColor)
      value = sprintf("%d", @options[index].optstart + self[index])
      xpos += optionwidth - self.contents.text_size(value).width
      pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                       @selBaseColor, @selShadowColor)
    else
      value = @options[index].values[self[index]]
      xpos = optionwidth + rect.x
      pbDrawShadowText(self.contents, xpos, rect.y, optionwidth, rect.height, value,
                       @selBaseColor, @selShadowColor)
    end
  end

  def update
    oldindex = self.index
    @mustUpdateOptions = false
    super
    dorefresh = (self.index != oldindex)
    if self.active && self.index < @options.length
      if Input.repeat?(Input::LEFT)
        self[self.index] = @options[self.index].prev(self[self.index])
        dorefresh =
          @selected_position = self[self.index]
        @mustUpdateOptions = true
        @mustUpdateDescription = true
      elsif Input.repeat?(Input::RIGHT)
        self[self.index] = @options[self.index].next(self[self.index])
        dorefresh = true
        @selected_position = self[self.index]
        @mustUpdateOptions = true
        @mustUpdateDescription = true
      end
    end
    refresh if dorefresh
  end
end

#===============================================================================
# Options main screen
#===============================================================================
class PokemonOption_Scene
  def getDefaultDescription
    return _INTL("Speech frame {1}.", 1 + $PokemonSystem.textskin)
  end

  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    if @sprites["option"].mustUpdateDescription
      updateDescription(@sprites["option"].index)
      @sprites["option"].descriptionUpdated
    end
  end

  def initialize
    @autosave_menu = false
  end

  def initUIElements
    @sprites["title"] = Window_UnformattedTextPokemon.newWithSize(
      _INTL("Options"), 0, 0, Graphics.width, 64, @viewport)
    @sprites["textbox"] = pbCreateMessageWindow
    @sprites["textbox"].text = _INTL("Speech frame {1}.", 1 + $PokemonSystem.textskin)
    @sprites["textbox"].letterbyletter = false
    pbSetSystemFont(@sprites["textbox"].contents)
  end

  def pbStartScene(inloadscreen = false)
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    initUIElements
    # These are the different options in the game. To add an option, define a
    # setter and a getter for that option. To delete an option, comment it out
    # or delete it. The game's options may be placed in any order.
    @PokemonOptions = pbGetOptions(inloadscreen)
    @PokemonOptions = pbAddOnOptions(@PokemonOptions)
    @sprites["option"] = initOptionsWindow
    # Get the values of each option
    for i in 0...@PokemonOptions.length
      @sprites["option"].setValueNoRefresh(i, (@PokemonOptions[i].get || 0))
    end
    @sprites["option"].refresh
    pbDeactivateWindows(@sprites)
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  def initOptionsWindow
    optionsWindow = Window_PokemonOption.new(@PokemonOptions, 0,
                                             @sprites["title"].height, Graphics.width,
                                             Graphics.height - @sprites["title"].height - @sprites["textbox"].height)
    optionsWindow.viewport = @viewport
    optionsWindow.visible = true
    return optionsWindow
  end

  def updateDescription(index)
    index = 0 if !index
    begin
      horizontal_position = @sprites["option"].selected_position
      optionDescription = @PokemonOptions[index].description
      if optionDescription.is_a?(Array)
        if horizontal_position < optionDescription.size
          new_description = optionDescription[horizontal_position]
        else
          new_description = getDefaultDescription
        end
      else
        new_description = optionDescription
      end

      new_description = getDefaultDescription if new_description == ""
      @sprites["textbox"].text = _INTL(new_description)
    rescue
      @sprites["textbox"].text = getDefaultDescription
    end
  end

  def pbGetOptions(inloadscreen = false)
    options = []
    options << SliderOption.new(_INTL("Music Volume"), 0, 100, 5,
                                proc { $PokemonSystem.bgmvolume },
                                proc { |value|
                                  if $PokemonSystem.bgmvolume != value
                                    $PokemonSystem.bgmvolume = value
                                    if $game_system.playing_bgm != nil && !inloadscreen
                                      playingBGM = $game_system.getPlayingBGM
                                      $game_system.bgm_pause
                                      $game_system.bgm_resume(playingBGM)
                                    end
                                  end
                                }, "Sets the volume for background music"
    )

    options << SliderOption.new(_INTL("SE Volume"), 0, 100, 5,
                                proc { $PokemonSystem.sevolume },
                                proc { |value|
                                  if $PokemonSystem.sevolume != value
                                    $PokemonSystem.sevolume = value
                                    if $game_system.playing_bgs != nil
                                      $game_system.playing_bgs.volume = value
                                      playingBGS = $game_system.getPlayingBGS
                                      $game_system.bgs_pause
                                      $game_system.bgs_resume(playingBGS)
                                    end
                                    pbPlayCursorSE
                                  end
                                }, "Sets the volume for sound effects"
    )
    options << EnumOption.new(_INTL("Text Speed"), [_INTL("Normal"), _INTL("Fast")],
                              proc { $PokemonSystem.textspeed },
                              proc { |value|
                                $PokemonSystem.textspeed = value
                                MessageConfig.pbSetTextSpeed(MessageConfig.pbSettingToTextSpeed(value))
                              }, "Sets the speed at which the text is displayed"
    )
    # if $game_switches && ($game_switches[SWITCH_NEW_GAME_PLUS] || $game_switches[SWITCH_BEAT_THE_LEAGUE]) #beat the league
    #   options << EnumOption.new(_INTL("Text Speed"), [_INTL("Normal"), _INTL("Fast"), _INTL("Instant")],
    #                             proc { $PokemonSystem.textspeed },
    #                             proc { |value|
    #                               $PokemonSystem.textspeed = value
    #                               MessageConfig.pbSetTextSpeed(MessageConfig.pbSettingToTextSpeed(value))
    #                             }, "Sets the speed at which the text is displayed"
    #   )
    # else
    #   options << EnumOption.new(_INTL("Text Speed"), [_INTL("Normal"), _INTL("Fast")],
    #                             proc { $PokemonSystem.textspeed },
    #                             proc { |value|
    #                               $PokemonSystem.textspeed = value
    #                               MessageConfig.pbSetTextSpeed(MessageConfig.pbSettingToTextSpeed(value))
    #                             }, "Sets the speed at which the text is displayed"
    #   )
    # end
    options <<
      EnumOption.new(_INTL("Download sprites"), [_INTL("On"), _INTL("Off")],
                     proc { $PokemonSystem.download_sprites},
                     proc { |value|
                       $PokemonSystem.download_sprites = value
                     },
                     "Automatically download custom sprites from the internet"
      )




    if $game_switches
      options <<
        EnumOption.new(_INTL("Autosave"), [_INTL("On"), _INTL("Off")],
                       proc { $game_switches[AUTOSAVE_ENABLED_SWITCH] ? 0 : 1 },
                       proc { |value|
                         if !$game_switches[AUTOSAVE_ENABLED_SWITCH] && value == 0
                           @autosave_menu = true
                           openAutosaveMenu()
                         end
                         $game_switches[AUTOSAVE_ENABLED_SWITCH] = value == 0
                       },
                       "Automatically saves when healing at Pokémon centers"
        )
    end

    if $game_switches && ($game_switches[SWITCH_NEW_GAME_PLUS] || $game_switches[SWITCH_BEAT_THE_LEAGUE]) #beat the league
      options <<
        EnumOption.new(_INTL("Battle type"), [_INTL("1v1"), _INTL("2v2"), _INTL("3v3")],
                       proc { $PokemonSystem.battle_type },
                       proc { |value|
                         if value == 0
                           $game_variables[VAR_DEFAULT_BATTLE_TYPE] = [1, 1]
                         elsif value == 1
                           $game_variables[VAR_DEFAULT_BATTLE_TYPE] = [2, 2]
                         elsif value == 2
                           $game_variables[VAR_DEFAULT_BATTLE_TYPE] = [3, 3]
                         else
                           $game_variables[VAR_DEFAULT_BATTLE_TYPE] = [1, 1]
                         end
                         $PokemonSystem.battle_type = value
                       }, "Sets the number of Pokémon sent out in battles (when possible)"
        )
    end

    options <<
      EnumOption.new(_INTL("Double Wild"), [_INTL("Off"), _INTL("On"), _INTL("Triple!")],
                      proc { $PokemonSystem.force_double_wild },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.force_double_wild = 0
                        elsif value == 1
                          $PokemonSystem.force_double_wild = 1
                        elsif value == 2
                          $PokemonSystem.force_double_wild = 2
                        end
                        $PokemonSystem.force_double_wild = value
                      }, "Double wild or nah ?"
    )

    # options <<
    #   EnumOption.new(_INTL("Double Wild"), [_INTL("Off"), _INTL("On")],
    #                   proc { $PokemonSystem.force_double_wild },
    #                   proc { |value|
    #                     if value == 0
    #                       $PokemonSystem.force_double_wild = 0
    #                     elsif value == 1
    #                       $PokemonSystem.force_double_wild = 1
    #                     end
    #                     $PokemonSystem.force_double_wild = value
    #                   }, "Double wild or nah ?"
    # )

    #KurayX
    options <<
      EnumOption.new(_INTL("Shiny Icons"), [_INTL("Off"), _INTL("On")],
                      proc { $PokemonSystem.shiny_icons_kuray },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.shiny_icons_kuray = 0
                        elsif value == 1
                          $PokemonSystem.shiny_icons_kuray = 1
                        end
                        $PokemonSystem.shiny_icons_kuray = value
                      }, "Makes shiny icons for shiny pokemons, reduces performances !"
    )

    options << EnumOption.new(_INTL("Battle Effects"), [_INTL("On"), _INTL("Off")],
                              proc { $PokemonSystem.battlescene },
                              proc { |value| $PokemonSystem.battlescene = value },
                              "Display move animations in battles"
    )

    options << EnumOption.new(_INTL("Shiny Animation"), [_INTL("On"), _INTL("Off"), _INTL("All")],
                              proc { $PokemonSystem.kurayshinyanim },
                              proc { |value| $PokemonSystem.kurayshinyanim = value },
                              "Display the shiny animations in battles"
    )

    options << EnumOption.new(_INTL("Battle Style"), [_INTL("Switch"), _INTL("Set")],
                              proc { $PokemonSystem.battlestyle },
                              proc { |value| $PokemonSystem.battlestyle = value },
                              ["Prompts to switch Pokémon before the opponent sends out the next one",
                               "No prompt to switch Pokémon before the opponent sends the next one"]
    )

    options << EnumOption.new(_INTL("Default Movement"), [_INTL("Walking"), _INTL("Running")],
                              proc { $PokemonSystem.runstyle },
                              proc { |value| $PokemonSystem.runstyle = value },
                              ["Default to walking when not holding the Run key",
                               "Default to running when not holding the Run key"]
    )

    options << NumberOption.new(_INTL("Speech Frame"), 1, Settings::SPEECH_WINDOWSKINS.length,
                                proc { $PokemonSystem.textskin },
                                proc { |value|
                                  $PokemonSystem.textskin = value
                                  MessageConfig.pbSetSpeechFrame("Graphics/Windowskins/" + Settings::SPEECH_WINDOWSKINS[value])
                                }
    )
    # NumberOption.new(_INTL("Menu Frame"),1,Settings::MENU_WINDOWSKINS.length,
    #   proc { $PokemonSystem.frame },
    #   proc { |value|
    #     $PokemonSystem.frame = value
    #     MessageConfig.pbSetSystemFrame("Graphics/Windowskins/" + Settings::MENU_WINDOWSKINS[value])
    #   }
    # ),
    options << EnumOption.new(_INTL("Text Entry"), [_INTL("Cursor"), _INTL("Keyboard")],
                              proc { $PokemonSystem.textinput },
                              proc { |value| $PokemonSystem.textinput = value },
                              ["Enter text by selecting letters on the screen",
                               "Enter text by typing on the keyboard"]
    )
    if $game_variables
      options << EnumOption.new(_INTL("Fusion icons"), [_INTL("Combined"), _INTL("DNA")],
                                proc { $game_variables[VAR_FUSION_ICON_STYLE] },
                                proc { |value| $game_variables[VAR_FUSION_ICON_STYLE] = value },
                                ["Combines both Pokémon's party icons",
                                 "Uses the same party icon for all fusions"]
      )
    end
    #Sylvi Big Icons
    options << EnumOption.new(_INTL("Big Pokémon Icons"), [_INTL("Off"), _INTL("Limited"), _INTL("All")],
                              proc { $PokemonSystem.kuraybigicons },
                              proc { |value| $PokemonSystem.kuraybigicons = value },
                              ["Pokémon will use their small box sprites for icons",
                               "Pokémon icons will use their full-size battle sprites (except in boxes)",
                               "Pokémon icons will use their full-size battle sprites"]
    )
    options << EnumOption.new(_INTL("Screen Size"), [_INTL("S"), _INTL("M"), _INTL("L"), _INTL("XL"), _INTL("Full")],
                              proc { [$PokemonSystem.screensize, 4].min },
                              proc { |value|
                                if $PokemonSystem.screensize != value
                                  $PokemonSystem.screensize = value
                                  pbSetResizeFactor($PokemonSystem.screensize)
                                end
                              }, "Sets the size of the screen"
    )
    options << EnumOption.new(_INTL("Quick Field Moves"), [_INTL("Off"), _INTL("On")],
                              proc { $PokemonSystem.quicksurf },
                              proc { |value| $PokemonSystem.quicksurf = value },
                              "Use Field Moves quicker"
    )
    #KurayX
    options <<
      EnumOption.new(_INTL("Enable EvoLock"), [_INTL("Off"), _INTL("On")],
                      proc { $PokemonSystem.kuray_no_evo },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.kuray_no_evo = 0
                        elsif value == 1
                          $PokemonSystem.kuray_no_evo = 1
                        end
                        $PokemonSystem.kuray_no_evo = value
                      }, "Toggle on/off evolutions for each individual Pokemons when selected in pc"
    )
    #KurayX
    options <<
      EnumOption.new(_INTL("Shiny Fuse Dye"), [_INTL("Off"), _INTL("On"), _INTL("Random")],
                      proc { $PokemonSystem.shinyfusedye },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.shinyfusedye = 0
                        elsif value == 1
                          $PokemonSystem.shinyfusedye = 1
                        elsif value == 2
                          $PokemonSystem.shinyfusedye = 2
                        end
                        $PokemonSystem.shinyfusedye = value
                      }, "Toggle on/off shiny color dye when fusing. Random re-roll entirely the shiny color"
    )
    #KurayX
    options <<
      EnumOption.new(_INTL("Fusion Preview"), [_INTL("Off"), _INTL("On")],
                      proc { $PokemonSystem.kurayfusepreview },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.kurayfusepreview = 0
                        elsif value == 1
                          $PokemonSystem.kurayfusepreview = 1
                        end
                        $PokemonSystem.kurayfusepreview = value
                      }, "If enabled, allows you to ALWAYS see what the fusion results looks like"
    )
    #KurayX
    options <<
      EnumOption.new(_INTL("Kuray QoL"), [_INTL("Off"), _INTL("On")],
                      proc { $PokemonSystem.kurayqol },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.kurayqol = 0
                        elsif value == 1
                          $PokemonSystem.kurayqol = 1
                        end
                        $PokemonSystem.kurayqol = value
                      }, "Activates Kuray's QoL features (list on Discord)"
    )
    #KurayX
    options <<
      EnumOption.new(_INTL("Level Cap"), [_INTL("Off"), _INTL("Easy"), _INTL("Normal"), _INTL("Hard")],
                      proc { $PokemonSystem.kuraylevelcap },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.kuraylevelcap = 0
                        elsif value == 1
                          $PokemonSystem.kuraylevelcap = 1
                        elsif value == 2
                          $PokemonSystem.kuraylevelcap = 2
                        elsif value == 3
                          $PokemonSystem.kuraylevelcap = 3
                        end
                        $PokemonSystem.kuraylevelcap = value
                      }, "Gives your Pokemons a level cap that increases with the game story"
    )
    #KurayX
    options <<
      EnumOption.new(_INTL("Shiny Revamp"), [_INTL("On"), _INTL("Off")],
                      proc { $PokemonSystem.kuraynormalshiny },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.kuraynormalshiny = 0
                        elsif value == 1
                          $PokemonSystem.kuraynormalshiny = 1
                        end
                        $PokemonSystem.kuraynormalshiny = value
                      }, "If OFF, disable the Shiny Revamp, shinies back to vanilla"
    )
    #KurayX
    options <<
      EnumOption.new(_INTL("Kuray's Shenanigans"), [_INTL("On"), _INTL("Off")],
                      proc { $PokemonSystem.shenanigans },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.shenanigans = 0
                        elsif value == 1
                          $PokemonSystem.shenanigans = 1
                        end
                        $PokemonSystem.shenanigans = value
                      }, "If OFF, remove the joke features and potentially unwanted features"
    )
    if $PokemonSystem.kuraygambleodds == nil || !$PokemonSystem.kuraygambleodds
      $PokemonSystem.kuraygambleodds = 100
    end
    options << SliderOption.new(_INTL("Shiny Gamble Odds"), 0, 1000, 10,
                                proc { $PokemonSystem.kuraygambleodds },
                                proc { |value|
                                  if $PokemonSystem.kuraygambleodds != value
                                    $PokemonSystem.kuraygambleodds = value
                                  end
                                }, "1 out of <x> | Choose the odds of Shinies from Gamble | 0 = Always"
    )
    #KurayX
    options <<
      EnumOption.new(_INTL("Game's Font"), [_INTL("Default "), _INTL("FR/LG "), _INTL("D/P "), _INTL("R/B")],
                      proc { $PokemonSystem.kurayfonts },
                      proc { |value|
                        if value == 0
                          $PokemonSystem.kurayfonts = 0
                          # MessageConfig::FONT_SIZE = 29
                          # MessageConfig::NARROW_FONT_SIZE = 29
                          MessageConfig.pbGetSystemFontSizeset(29)
                          MessageConfig.pbGetSmallFontSizeset(25)
                          MessageConfig.pbGetNarrowFontSizeset(29)
                          MessageConfig.pbSetSystemFontName("Power Green")
                          MessageConfig.pbSetSmallFontName("Power Green Small")
                          MessageConfig.pbSetNarrowFontName("Power Green Narrow")
                          MessageConfig.pbGetSystemFontSizeset(29)
                          MessageConfig.pbGetSmallFontSizeset(25)
                          MessageConfig.pbGetNarrowFontSizeset(29)
                        elsif value == 1
                          $PokemonSystem.kurayfonts = 1
                          # MessageConfig::FONT_SIZE = 26
                          # MessageConfig::NARROW_FONT_SIZE = 26
                          MessageConfig.pbGetSystemFontSizeset(26)
                          MessageConfig.pbGetSmallFontSizeset(25)
                          MessageConfig.pbGetNarrowFontSizeset(26)
                          MessageConfig.pbSetSystemFontName("Power Red and Green")
                          MessageConfig.pbSetSmallFontName("Power Green Small")
                          MessageConfig.pbSetNarrowFontName("Power Green Small")
                        elsif value == 2
                          $PokemonSystem.kurayfonts = 2
                          MessageConfig.pbGetSystemFontSizeset(29)
                          MessageConfig.pbGetSmallFontSizeset(25)
                          MessageConfig.pbGetNarrowFontSizeset(29)
                          MessageConfig.pbSetSystemFontName("Power Clear")
                          MessageConfig.pbSetSmallFontName("Power Clear")
                          MessageConfig.pbSetNarrowFontName("Power Clear")
                        elsif value == 3
                          $PokemonSystem.kurayfonts = 3
                          MessageConfig.pbGetSystemFontSizeset(29)
                          MessageConfig.pbGetSmallFontSizeset(25)
                          MessageConfig.pbGetNarrowFontSizeset(29)
                          MessageConfig.pbSetSystemFontName("Power Red and Blue")
                          MessageConfig.pbSetSmallFontName("Power Red and Blue")
                          MessageConfig.pbSetNarrowFontName("Power Red and Blue")
                        end
                        $PokemonSystem.kurayfonts = value
                      }, "Changes the Game's font"
    )


    return options
  end

  def pbAddOnOptions(options)
    return options
  end

  def openAutosaveMenu()
    return if !@autosave_menu
    pbFadeOutIn {
      scene = AutosaveOptionsScene.new
      screen = PokemonOptionScreen.new(scene)
      screen.pbStartScreen
    }
    @autosave_menu = false
  end

  def pbOptions
    oldSystemSkin = $PokemonSystem.frame # Menu
    oldTextSkin = $PokemonSystem.textskin # Speech
    pbActivateWindow(@sprites, "option") {
      loop do
        Graphics.update
        Input.update
        pbUpdate
        if @sprites["option"].mustUpdateOptions
          # Set the values of each option
          for i in 0...@PokemonOptions.length
            @PokemonOptions[i].set(@sprites["option"][i])
          end
          if $PokemonSystem.textskin != oldTextSkin
            @sprites["textbox"].setSkin(MessageConfig.pbGetSpeechFrame())
            @sprites["textbox"].text = _INTL("Speech frame {1}.", 1 + $PokemonSystem.textskin)
            oldTextSkin = $PokemonSystem.textskin
          end
          if $PokemonSystem.frame != oldSystemSkin
            @sprites["title"].setSkin(MessageConfig.pbGetSystemFrame())
            @sprites["option"].setSkin(MessageConfig.pbGetSystemFrame())
            oldSystemSkin = $PokemonSystem.frame
          end
        end
        if Input.trigger?(Input::BACK)
          break
        elsif Input.trigger?(Input::USE)
          break if isConfirmedOnKeyPress
        end
      end
    }
  end

  def isConfirmedOnKeyPress
    return @sprites["option"].index == @PokemonOptions.length
  end

  def pbEndScene
    pbPlayCloseMenuSE
    pbFadeOutAndHide(@sprites) { pbUpdate }
    # Set the values of each option
    for i in 0...@PokemonOptions.length
      @PokemonOptions[i].set(@sprites["option"][i])
    end
    pbDisposeMessageWindow(@sprites["textbox"])
    pbDisposeSpriteHash(@sprites)
    pbRefreshSceneMap
    @viewport.dispose
  end
end

#===============================================================================
#
#===============================================================================
class PokemonOptionScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen(inloadscreen = false)
    @scene.pbStartScene(inloadscreen)
    @scene.pbOptions
    @scene.pbEndScene
  end
end
