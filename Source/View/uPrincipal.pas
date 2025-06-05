unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, System.Generics.Collections, uCepModel, uCepController, uViaCepService, System.UITypes;

type
  TfrmPrincipal = class(TForm)
    pnlTop: TPanel;
    lblCep: TLabel;
    edtCep: TEdit;
    btnConsultarCep: TButton;
    lblUf: TLabel;
    edtUf: TEdit;
    lblCidade: TLabel;
    edtCidade: TEdit;
    lblLogradouro: TLabel;
    edtLogradouro: TEdit;
    btnConsultarEndereco: TButton;
    rgTipoConsulta: TRadioGroup;
    pnlResultado: TPanel;
    lblResultado: TLabel;
    grdResultado: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnConsultarCepClick(Sender: TObject);
    procedure btnConsultarEnderecoClick(Sender: TObject);
    procedure rgTipoConsultaClick(Sender: TObject);
  private
    FCepController: TCepController;
    procedure LimparCampos;
    procedure ConfigurarGrid;
    procedure ExibirResultadoCep(const ACep: TCepModel);
    procedure ExibirResultadoEndereco(const ALista: TList<TCepModel>);
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  FCepController := TCepController.Create;
  ConfigurarGrid;
  rgTipoConsulta.ItemIndex := 0;
  LimparCampos;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
  if Assigned(FCepController) then
    FCepController.Free;
end;

procedure TfrmPrincipal.ConfigurarGrid;
begin
  with grdResultado do
  begin
    ColCount := 6;
    RowCount := 2;
    FixedRows := 1;
    
    // Configurar cabeçalhos
    Cells[0, 0] := 'CEP';
    Cells[1, 0] := 'Logradouro';
    Cells[2, 0] := 'Complemento';
    Cells[3, 0] := 'Bairro';
    Cells[4, 0] := 'Cidade';
    Cells[5, 0] := 'UF';
    
    // Configurar larguras das colunas
    ColWidths[0] := 100;
    ColWidths[1] := 200;
    ColWidths[2] := 150;
    ColWidths[3] := 100;
    ColWidths[4] := 150;
    ColWidths[5] := 50;
  end;
end;

procedure TfrmPrincipal.LimparCampos;
  var i : Integer;
begin
  edtCep.Clear;
  edtUf.Clear;
  edtCidade.Clear;
  edtLogradouro.Clear;

  grdResultado.RowCount := 2;
  for i := 1 to grdResultado.ColCount - 1 do
    grdResultado.Cells[i, 1] := '';
end;

procedure TfrmPrincipal.ExibirResultadoCep(const ACep: TCepModel);
begin
  if Assigned(ACep) then
  begin
    with grdResultado do
    begin
      RowCount := 2;
      Cells[0, 1] := ACep.Cep;
      Cells[1, 1] := ACep.Logradouro;
      Cells[2, 1] := ACep.Complemento;
      Cells[3, 1] := ACep.Bairro;
      Cells[4, 1] := ACep.Localidade;
      Cells[5, 1] := ACep.Uf;
    end;
  end;
end;

procedure TfrmPrincipal.ExibirResultadoEndereco(const ALista: TList<TCepModel>);
var
  LCep: TCepModel;
  i: Integer;
begin
  if Assigned(ALista) and (ALista.Count > 0) then
  begin
    grdResultado.RowCount := ALista.Count + 1;
    i := 1;
    
    for LCep in ALista do
    begin
      with grdResultado do
      begin
        Cells[0, i] := LCep.Cep;
        Cells[1, i] := LCep.Logradouro;
        Cells[2, i] := LCep.Complemento;
        Cells[3, i] := LCep.Bairro;
        Cells[4, i] := LCep.Localidade;
        Cells[5, i] := LCep.Uf;
      end;
      Inc(i);
    end;
  end;
end;

procedure TfrmPrincipal.btnConsultarCepClick(Sender: TObject);
var
  LCep: TCepModel;
  LCepExistente: TCepModel;
begin
  try
    LCepExistente := FCepController.BuscarCepExistente(edtCep.Text);
    try
      if Assigned(LCepExistente) then
      begin
        if MessageDlg('CEP já cadastrado. Deseja atualizar com dados do ViaCEP?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          LCep := FCepController.ConsultarPorCep(edtCep.Text);
          try
            ExibirResultadoCep(LCep);
            FCepController.SalvarCep(LCep);
          finally
            LCep.Free;
          end;
        end
        else
        begin
          ExibirResultadoCep(LCepExistente);
        end;
      end
      else
      begin
        LCep := FCepController.ConsultarPorCep(edtCep.Text);
        try
          ExibirResultadoCep(LCep);
          FCepController.SalvarCep(LCep);
        finally
          LCep.Free;
        end;
      end;
    finally
      LCepExistente.Free;
    end;
  except
    on E: Exception do
    begin
      if E.Message.Contains('não encontrado') then
        ShowMessage('CEP não encontrado no ViaCEP.')
      else
        ShowMessage(E.Message);
      LimparCampos;
    end;
  end;
end;

procedure TfrmPrincipal.btnConsultarEnderecoClick(Sender: TObject);
var
  LLista: TList<TCepModel>;
  LCep: TCepModel;
  LCepExistente: TCepModel;
begin
  try
    LCepExistente := FCepController.BuscarEnderecoExistente(
      edtUf.Text,
      edtCidade.Text,
      edtLogradouro.Text
    );
    try
      if Assigned(LCepExistente) then
      begin
        if MessageDlg('Endereço já cadastrado. Deseja atualizar com dados do ViaCEP?',
          mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          LLista := FCepController.ConsultarPorEndereco(
            edtUf.Text,
            edtCidade.Text,
            edtLogradouro.Text
          );
          try
            if LLista.Count = 0 then
            begin
              ShowMessage('Nenhum endereço encontrado no ViaCEP.');
              Exit;
            end;

            ExibirResultadoEndereco(LLista);
            for LCep in LLista do
              FCepController.SalvarCep(LCep);
          finally
            LLista.Free;
          end;
        end
        else
        begin
          ExibirResultadoCep(LCepExistente);
        end;
      end
      else
      begin
        LLista := FCepController.ConsultarPorEndereco(
          edtUf.Text,
          edtCidade.Text,
          edtLogradouro.Text
        );
        try
          if LLista.Count = 0 then
          begin
            ShowMessage('Nenhum endereço encontrado no ViaCEP.');
            Exit;
          end;

          ExibirResultadoEndereco(LLista);
          for LCep in LLista do
            FCepController.SalvarCep(LCep);
        finally
          LLista.Free;
        end;
      end;
    finally
      LCepExistente.Free;
    end;
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure TfrmPrincipal.rgTipoConsultaClick(Sender: TObject);
begin
  FCepController.FormatoResposta := TFormatoResposta(rgTipoConsulta.ItemIndex);
end;

end. 