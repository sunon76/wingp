object frmGPSpooler: TfrmGPSpooler
  Left = 419
  Top = 189
  Width = 674
  Height = 423
  Caption = 'GPSpooler'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 666
    Height = 389
    ActivePage = TabSheet2
    Align = alClient
    TabIndex = 1
    TabOrder = 0
    object tshJobs: TTabSheet
      Caption = 'Jobs'
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 658
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object btnUpdate: TButton
          Left = 16
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Update'
          TabOrder = 0
        end
      end
      object pnlJobs: TScrollBox
        Left = 0
        Top = 41
        Width = 658
        Height = 320
        VertScrollBar.Smooth = True
        Align = alClient
        TabOrder = 1
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Settings'
      ImageIndex = 1
      object GroupBox1: TGroupBox
        Left = 0
        Top = 8
        Width = 185
        Height = 185
        Caption = 'Environment Variables'
        TabOrder = 0
        object btnSetEnv: TButton
          Left = 6
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Install'
          TabOrder = 0
          OnClick = btnSetEnvClick
        end
        object rbCurrentUser: TRadioButton
          Left = 16
          Top = 112
          Width = 113
          Height = 17
          Caption = 'For Current User'
          TabOrder = 1
        end
        object rbSystem: TRadioButton
          Left = 16
          Top = 136
          Width = 113
          Height = 17
          Caption = 'For All'
          Checked = True
          TabOrder = 2
          TabStop = True
        end
        object btnDelEnv: TButton
          Left = 88
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Uninstall'
          TabOrder = 3
          OnClick = btnDelEnvClick
        end
        object Panel2: TPanel
          Left = 0
          Top = 48
          Width = 185
          Height = 28
          AutoSize = True
          TabOrder = 4
          object lbEnv2: TLabel
            Left = 1
            Top = 14
            Width = 183
            Height = 13
            Align = alTop
            Caption = 'lbEnv2'
            WordWrap = True
          end
          object lbEnv1: TLabel
            Left = 1
            Top = 1
            Width = 183
            Height = 13
            Align = alTop
            Caption = 'lbEnv1'
            WordWrap = True
          end
        end
      end
    end
  end
  object TrayIcon1: TTrayIcon
    Visible = True
    Hide = True
    RestoreOn = imDoubleClick
    PopupMenuOn = imNone
    Left = 616
    Top = 344
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 560
    Top = 344
  end
end
