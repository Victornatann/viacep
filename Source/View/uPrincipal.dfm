object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Consulta CEP'
  ClientHeight = 600
  ClientWidth = 800
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 800
    Height = 91
    Align = alTop
    TabOrder = 0
    object lblCep: TLabel
      Left = 16
      Top = 16
      Width = 24
      Height = 15
      Caption = 'CEP:'
    end
    object lblUf: TLabel
      Left = 16
      Top = 49
      Width = 17
      Height = 15
      Caption = 'UF:'
    end
    object lblCidade: TLabel
      Left = 184
      Top = 50
      Width = 40
      Height = 15
      Caption = 'Cidade:'
    end
    object lblLogradouro: TLabel
      Left = 368
      Top = 50
      Width = 65
      Height = 15
      Caption = 'Logradouro:'
    end
    object edtCep: TEdit
      Left = 47
      Top = 13
      Width = 121
      Height = 23
      TabOrder = 0
    end
    object edtUf: TEdit
      Left = 47
      Top = 46
      Width = 121
      Height = 23
      MaxLength = 2
      TabOrder = 1
    end
    object edtCidade: TEdit
      Left = 234
      Top = 47
      Width = 121
      Height = 23
      TabOrder = 2
    end
    object edtLogradouro: TEdit
      Left = 447
      Top = 47
      Width = 121
      Height = 23
      TabOrder = 3
    end
    object btnConsultarCep: TButton
      Left = 174
      Top = 12
      Width = 75
      Height = 25
      Caption = 'Consultar'
      TabOrder = 4
      OnClick = btnConsultarCepClick
    end
    object btnConsultarEndereco: TButton
      Left = 574
      Top = 46
      Width = 75
      Height = 25
      Caption = 'Consultar'
      TabOrder = 5
      OnClick = btnConsultarEnderecoClick
    end
    object rgTipoConsulta: TRadioGroup
      Left = 654
      Top = 12
      Width = 130
      Height = 71
      Caption = 'Formato da Resposta'
      ItemIndex = 0
      Items.Strings = (
        'JSON'
        'XML')
      TabOrder = 6
      OnClick = rgTipoConsultaClick
    end
  end
  object pnlResultado: TPanel
    Left = 0
    Top = 91
    Width = 800
    Height = 509
    Align = alClient
    TabOrder = 1
    object lblResultado: TLabel
      Left = 16
      Top = 16
      Width = 55
      Height = 15
      Caption = 'Resultado:'
    end
    object grdResultado: TStringGrid
      Left = 16
      Top = 37
      Width = 768
      Height = 447
      ColCount = 6
      FixedCols = 0
      RowCount = 2
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing]
      TabOrder = 0
      ColWidths = (
        100
        200
        150
        100
        150
        50)
      RowHeights = (
        24
        24)
    end
  end
end
