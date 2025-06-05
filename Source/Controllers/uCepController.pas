unit uCepController;

interface

uses
  System.SysUtils, System.Classes, Vcl.Dialogs, System.UITypes,
  uCepModel, uCepService, uViaCepService, uCepDAO, System.Generics.Collections;

type
  TCepController = class
  private
    FCepService: ICepService;
    FCepDAO: TCepDAO;
    procedure ValidarCep(const ACep: string);
    procedure ValidarEndereco(const AUf, ACidade, ALogradouro: string);
    function GetFormatoResposta: TFormatoResposta;
    procedure SetFormatoResposta(const Value: TFormatoResposta);
  public
    constructor Create;
    destructor Destroy; override;

    property FormatoResposta: TFormatoResposta read GetFormatoResposta write SetFormatoResposta;

    function ConsultarPorCep(const ACep: string): TCepModel;
    function ConsultarPorEndereco(const AUf, ACidade, ALogradouro: string): TList<TCepModel>;
    procedure SalvarCep(const ACep: TCepModel);
    function BuscarCepExistente(const ACep: string): TCepModel;
    function BuscarEnderecoExistente(const AUf, ACidade, ALogradouro: string): TCepModel;
  end;

implementation

constructor TCepController.Create;
begin
  inherited Create;
  FCepService := TViaCepService.Create;
  FCepDAO := TCepDAO.Create;
end;

destructor TCepController.Destroy;
begin
  FCepService := Nil;
  FCepDAO.Free;
  inherited;
end;

procedure TCepController.ValidarCep(const ACep: string);
begin
  if Trim(ACep) = '' then
    raise Exception.Create('Por favor, informe o CEP.');
end;

procedure TCepController.ValidarEndereco(const AUf, ACidade, ALogradouro: string);
begin
  if  AUf.Trim().IsEmpty() then
    raise Exception.Create('Por favor, informe a UF.');

  if ACidade.Trim().IsEmpty() then
    raise Exception.Create('Por favor, informe a cidade.');

  if ALogradouro.Trim().IsEmpty then
    raise Exception.Create('Por favor, informe o logradouro.');

  if not (AUf.Trim().Length > 1) then
    raise Exception.Create('Por favor, informe a UF válida.');
    
  if not (ACidade.Trim().Length > 3) then
    raise Exception.Create('Por favor, informe uma cidade válida.');
    
  if not (ALogradouro.Trim().Length > 3) then
    raise Exception.Create('Por favor, informe o logradouro válido.');
end;

function TCepController.ConsultarPorCep(const ACep: string): TCepModel;
begin
  ValidarCep(ACep);
  Result := FCepService.ConsultarPorCep(ACep);
end;

function TCepController.ConsultarPorEndereco(const AUf, ACidade, ALogradouro: string): TList<TCepModel>;
begin
  ValidarEndereco(AUf, ACidade, ALogradouro);
  Result := FCepService.ConsultarPorEndereco(AUf, ACidade, ALogradouro);
end;

procedure TCepController.SalvarCep(const ACep: TCepModel);
begin
  FCepDAO.Salvar(ACep);
end;

function TCepController.BuscarCepExistente(const ACep: string): TCepModel;
begin
  ValidarCep(ACep);
  Result := FCepDAO.BuscarPorCep(ACep);
end;

function TCepController.BuscarEnderecoExistente(const AUf, ACidade, ALogradouro: string): TCepModel;
begin
  ValidarEndereco(AUf, ACidade, ALogradouro);
  Result := FCepDAO.BuscarPorEndereco(AUf, ACidade, ALogradouro);
end;

function TCepController.GetFormatoResposta: TFormatoResposta;
begin
  Result := (FCepService as TViaCepService).FormatoResposta;
end;

procedure TCepController.SetFormatoResposta(const Value: TFormatoResposta);
begin
  (FCepService as TViaCepService).FormatoResposta := Value;
end;

end. 