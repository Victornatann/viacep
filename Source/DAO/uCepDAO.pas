unit uCepDAO;

interface

uses
  System.SysUtils, System.Classes, Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, uCepModel;

type
  TCepDAO = class
  private
    FConnection: TFDConnection;
    FQuery: TFDQuery;
    procedure ConfigurarConexao;
    procedure ConfigurarQuery;
    procedure CriarTabela;
  public
    constructor Create;
    destructor Destroy; override;
    
    procedure Salvar(const ACep: TCepModel);
    function BuscarPorCep(const ACep: string): TCepModel;
    function BuscarPorEndereco(const AUf, ACidade, ALogradouro: string): TCepModel;
  end;

implementation

constructor TCepDAO.Create;
begin
  inherited Create;
  try
    ConfigurarConexao;
    ConfigurarQuery;
    CriarTabela;
  except
    on E: Exception do
    begin
      if Assigned(FQuery) then FQuery.Free;
      if Assigned(FConnection) then FConnection.Free;
      raise Exception.Create('Erro ao inicializar DAO: ' + E.Message);
    end;
  end;
end;

destructor TCepDAO.Destroy;
begin
  FQuery.Free;
  FConnection.Free;
  inherited;
end;

procedure TCepDAO.ConfigurarConexao;
begin
  FConnection := TFDConnection.Create(nil);
  try
    FConnection.Params.Clear;
    FConnection.Params.Add('DriverID=SQLite');
    FConnection.Params.Add('Database=.\CepDatabase.db');
    FConnection.LoginPrompt := False;
    FConnection.Connected := True;
  except
    on E: Exception do
    begin
      FConnection.Free;
      raise Exception.Create('Erro ao configurar conexão com o banco de dados: ' + E.Message);
    end;
  end;
end;

procedure TCepDAO.ConfigurarQuery;
begin
  FQuery := TFDQuery.Create(nil);
  try
    FQuery.Connection := FConnection;
  except
    on E: Exception do
    begin
      FQuery.Free;
      raise Exception.Create('Erro ao configurar query: ' + E.Message);
    end;
  end;
end;

procedure TCepDAO.CriarTabela;
begin
  try
    FConnection.ExecSQL(
      'CREATE TABLE IF NOT EXISTS Ceps (' +
      'Codigo INTEGER PRIMARY KEY AUTOINCREMENT,' +
      'Cep VARCHAR(8) NOT NULL,' +
      'Logradouro VARCHAR(100),' +
      'Complemento VARCHAR(100),' +
      'Bairro VARCHAR(100),' +
      'Localidade VARCHAR(100),' +
      'Uf VARCHAR(2),' +
      'CONSTRAINT UK_Cep UNIQUE (Cep))');
  except
    on E: Exception do
      raise Exception.Create('Erro ao criar tabela: ' + E.Message);
  end;
end;

procedure TCepDAO.Salvar(const ACep: TCepModel);
var
  LCepExistente: TCepModel;
  LCepFormatado: string;
begin

  LCepFormatado := StringReplace(ACep.Cep, '-', '', [rfReplaceAll]);
  LCepExistente := BuscarPorCep(LCepFormatado);
  try
    if Assigned(LCepExistente) then
    begin
      FQuery.Close;
      FQuery.SQL.Text :=
        'UPDATE Ceps SET ' +
        'Logradouro = :Logradouro, ' +
        'Complemento = :Complemento, ' +
        'Bairro = :Bairro, ' +
        'Localidade = :Localidade, ' +
        'Uf = :Uf ' +
        'WHERE Cep = :Cep';
    end
    else
    begin
      FQuery.Close;
      FQuery.SQL.Text :=
        'INSERT INTO Ceps (Cep, Logradouro, Complemento, Bairro, Localidade, Uf) ' +
        'VALUES (:Cep, :Logradouro, :Complemento, :Bairro, :Localidade, :Uf)';
    end;

    FQuery.ParamByName('Cep').AsString := LCepFormatado;
    FQuery.ParamByName('Logradouro').AsString := ACep.Logradouro;
    FQuery.ParamByName('Complemento').AsString := ACep.Complemento;
    FQuery.ParamByName('Bairro').AsString := ACep.Bairro;
    FQuery.ParamByName('Localidade').AsString := ACep.Localidade;
    FQuery.ParamByName('Uf').AsString := ACep.Uf;

    FQuery.ExecSQL;
  finally
    LCepExistente.Free;
  end;
end;

function TCepDAO.BuscarPorCep(const ACep: string): TCepModel;
var
  LCepFormatado: string;
begin
  Result := nil;
  
  // Remove caracteres não numéricos
  LCepFormatado := StringReplace(ACep, '-', '', [rfReplaceAll]);
  LCepFormatado := StringReplace(LCepFormatado, '.', '', [rfReplaceAll]);
  LCepFormatado := StringReplace(LCepFormatado, ' ', '', [rfReplaceAll]);
  
  FQuery.Close;
  FQuery.SQL.Text := 'SELECT * FROM Ceps WHERE Cep = :Cep';
  FQuery.ParamByName('Cep').AsString := LCepFormatado;
  FQuery.Open;
  
  if not FQuery.Eof then
  begin
    Result := TCepModel.Create;
    Result.Cep := FQuery.FieldByName('Cep').AsString;
    Result.Logradouro := FQuery.FieldByName('Logradouro').AsString;
    Result.Complemento := FQuery.FieldByName('Complemento').AsString;
    Result.Bairro := FQuery.FieldByName('Bairro').AsString;
    Result.Localidade := FQuery.FieldByName('Localidade').AsString;
    Result.Uf := FQuery.FieldByName('Uf').AsString;
  end;
end;

function TCepDAO.BuscarPorEndereco(const AUf, ACidade, ALogradouro: string): TCepModel;
begin
  Result := nil;
  
  FQuery.Close;
  FQuery.SQL.Text :=
    'SELECT * FROM Ceps ' +
    'WHERE UPPER(Uf) = :Uf ' +
    'AND UPPER(Localidade) = :Localidade ' +
    'AND UPPER(Logradouro) LIKE :Logradouro';

  FQuery.ParamByName('Uf').AsString := UpperCase(AUf);
  FQuery.ParamByName('Localidade').AsString := UpperCase(ACidade);
  FQuery.ParamByName('Logradouro').AsString := '%' + UpperCase(ALogradouro) + '%';

  FQuery.Open;
  
  if not FQuery.Eof then
  begin
    Result := TCepModel.Create;
    Result.Cep := FQuery.FieldByName('Cep').AsString;
    Result.Logradouro := FQuery.FieldByName('Logradouro').AsString;
    Result.Complemento := FQuery.FieldByName('Complemento').AsString;
    Result.Bairro := FQuery.FieldByName('Bairro').AsString;
    Result.Localidade := FQuery.FieldByName('Localidade').AsString;
    Result.Uf := FQuery.FieldByName('Uf').AsString;
  end;
end;

end. 