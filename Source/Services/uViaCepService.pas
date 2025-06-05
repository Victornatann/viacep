unit uViaCepService;

interface

uses
  System.SysUtils, System.Classes, System.Net.HttpClient,
  System.Net.URLClient, System.JSON, System.JSON.Types,
  System.Generics.Collections, uCepModel, uCepService;

type
  TFormatoResposta = (frJson, frXml);

  TViaCepService = class(TInterfacedObject, ICepService)
  private
    FHttpClient: THTTPClient;
    FFormatoResposta: TFormatoResposta;
    function GetExtensao: string;
  public
    constructor Create;
    destructor Destroy; override;
    
    property FormatoResposta: TFormatoResposta read FFormatoResposta write FFormatoResposta;
    
    function ConsultarPorCep(const ACep: string): TCepModel;
    function ConsultarPorEndereco(const AUf, ACidade, ALogradouro: string): TList<TCepModel>;
  end;

implementation

constructor TViaCepService.Create;
begin
  inherited Create;
  FHttpClient := THTTPClient.Create;
  FFormatoResposta := frJson;
end;

destructor TViaCepService.Destroy;
begin
  FHttpClient.Free;
  inherited;
end;

function TViaCepService.GetExtensao: string;
begin
  case FFormatoResposta of
    frJson: Result := 'json';
    frXml: Result := 'xml';
  end;
end;

function TViaCepService.ConsultarPorCep(const ACep: string): TCepModel;
var
  LResponse: IHTTPResponse;
  LUrl: string;
begin
  LUrl := Format('https://viacep.com.br/ws/%s/%s/', [ACep, GetExtensao()]);
  
  LResponse := FHttpClient.Get(LUrl);
  
  if LResponse.StatusCode <> 200 then
    raise Exception.CreateFmt('Erro ao consultar CEP: %d - %s', 
      [LResponse.StatusCode, LResponse.ContentAsString]);
      
  case FFormatoResposta of
    frJson: Result := TCepModel.FromJson(LResponse.ContentAsString);
    frXml: Result := TCepModel.FromXml(LResponse.ContentAsString);
    else
    Result := TCepModel.FromXml(LResponse.ContentAsString);
  end;
end;

function TViaCepService.ConsultarPorEndereco(const AUf, ACidade, ALogradouro: string): TList<TCepModel>;
var
  LUrl: string;
  LResponse: string;
begin
  LUrl := Format('https://viacep.com.br/ws/%s/%s/%s/%s/',
    [AUf, ACidade, ALogradouro, GetExtensao]);
    
  try
    LResponse := FHttpClient.Get(LUrl).ContentAsString;
    
    if FormatoResposta = frJson then
      Result := TCepModel.ListFromJson(LResponse)
    else
      Result := TCepModel.ListFromXml(LResponse);
      
    if not Assigned(Result) or (Result.Count = 0) then
      raise Exception.Create('Nenhum endereço encontrado.');
  except
    on E: Exception do
    begin
      if E.Message.Contains('404') then
        raise Exception.Create('Nenhum endereço encontrado.')
      else
        raise Exception.Create('Erro ao consultar endereço: ' + E.Message);
    end;
  end;
end;

end. 