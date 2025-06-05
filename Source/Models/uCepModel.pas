unit uCepModel;

interface

uses
  System.SysUtils, System.Classes, System.JSON, System.NetEncoding,
  System.Generics.Collections, Xml.XMLDoc, Xml.XMLIntf;

type
  TCepModel = class
  private
    FCodigo: Integer;
    FCep: string;
    FLogradouro: string;
    FComplemento: string;
    FBairro: string;
    FLocalidade: string;
    FUf: string;
  public
    property Codigo: Integer read FCodigo write FCodigo;
    property Cep: string read FCep write FCep;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Complemento: string read FComplemento write FComplemento;
    property Bairro: string read FBairro write FBairro;
    property Localidade: string read FLocalidade write FLocalidade;
    property Uf: string read FUf write FUf;

    class function FromJson(const AJson: string): TCepModel; static;
    class function FromXml(const AXml: string): TCepModel; static;
    class function ListFromXml(const AXml: string): TList<TCepModel>; static;
    class function ListFromJson(const AJson: string): TList<TCepModel>; static;
    function ToJson: string;
    function ToXml: string;
  end;

implementation

class function TCepModel.FromJson(const AJson: string): TCepModel;
var
  LJsonObj: TJSONObject;
begin
  Result := TCepModel.Create;
  try
    LJsonObj := TJSONObject.ParseJSONValue(AJson) as TJSONObject;
    try
      Result.Cep := LJsonObj.GetValue('cep').Value;
      Result.Logradouro := LJsonObj.GetValue('logradouro').Value;
      Result.Complemento := LJsonObj.GetValue('complemento').Value;
      Result.Bairro := LJsonObj.GetValue('bairro').Value;
      Result.Localidade := LJsonObj.GetValue('localidade').Value;
      Result.Uf := LJsonObj.GetValue('uf').Value;
    finally
      LJsonObj.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TCepModel.FromXml(const AXml: string): TCepModel;
var
  LXmlDoc: IXMLDocument;
  LNode: IXMLNode;
begin
  Result := TCepModel.Create;
  try
    LXmlDoc := TXMLDocument.Create(nil);
    LXmlDoc.LoadFromXML(AXml);
    
    LNode := LXmlDoc.DocumentElement;
    
    if LNode.HasChildNodes then
    begin
      if LNode.ChildNodes.FindNode('cep') <> nil then
        Result.Cep := LNode.ChildNodes.FindNode('cep').Text;
        
      if LNode.ChildNodes.FindNode('logradouro') <> nil then
        Result.Logradouro := LNode.ChildNodes.FindNode('logradouro').Text;
        
      if LNode.ChildNodes.FindNode('complemento') <> nil then
        Result.Complemento := LNode.ChildNodes.FindNode('complemento').Text;
        
      if LNode.ChildNodes.FindNode('bairro') <> nil then
        Result.Bairro := LNode.ChildNodes.FindNode('bairro').Text;
        
      if LNode.ChildNodes.FindNode('localidade') <> nil then
        Result.Localidade := LNode.ChildNodes.FindNode('localidade').Text;
        
      if LNode.ChildNodes.FindNode('uf') <> nil then
        Result.Uf := LNode.ChildNodes.FindNode('uf').Text;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TCepModel.ListFromXml(const AXml: string): TList<TCepModel>;
var
  LXmlDoc: IXMLDocument;
  LNode, LEnderecosNode, LEnderecoNode: IXMLNode;
  i: Integer;
  LCep: TCepModel;
begin
  Result := TList<TCepModel>.Create;
  try
    LXmlDoc := TXMLDocument.Create(nil);
    LXmlDoc.LoadFromXML(AXml);
    
    LNode := LXmlDoc.DocumentElement;
    
    if LNode.HasChildNodes then
    begin
      LEnderecosNode := LNode.ChildNodes.FindNode('enderecos');
      if Assigned(LEnderecosNode) and LEnderecosNode.HasChildNodes then
      begin
        for i := 0 to LEnderecosNode.ChildNodes.Count - 1 do
        begin
          LEnderecoNode := LEnderecosNode.ChildNodes[i];
          if LEnderecoNode.NodeName = 'endereco' then
          begin
            LCep := TCepModel.Create;
            try
              if LEnderecoNode.ChildNodes.FindNode('cep') <> nil then
                LCep.Cep := LEnderecoNode.ChildNodes.FindNode('cep').Text;
                
              if LEnderecoNode.ChildNodes.FindNode('logradouro') <> nil then
                LCep.Logradouro := LEnderecoNode.ChildNodes.FindNode('logradouro').Text;
                
              if LEnderecoNode.ChildNodes.FindNode('complemento') <> nil then
                LCep.Complemento := LEnderecoNode.ChildNodes.FindNode('complemento').Text;
                
              if LEnderecoNode.ChildNodes.FindNode('bairro') <> nil then
                LCep.Bairro := LEnderecoNode.ChildNodes.FindNode('bairro').Text;
                
              if LEnderecoNode.ChildNodes.FindNode('localidade') <> nil then
                LCep.Localidade := LEnderecoNode.ChildNodes.FindNode('localidade').Text;
                
              if LEnderecoNode.ChildNodes.FindNode('uf') <> nil then
                LCep.Uf := LEnderecoNode.ChildNodes.FindNode('uf').Text;
                
              Result.Add(LCep);
            except
              LCep.Free;
              raise;
            end;
          end;
        end;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TCepModel.ListFromJson(const AJson: string): TList<TCepModel>;
var
  LJsonArray: TJSONArray;
  i: Integer;
  LCep: TCepModel;
begin
  Result := TList<TCepModel>.Create;
  try
    LJsonArray := TJSONObject.ParseJSONValue(AJson) as TJSONArray;
    try
      for i := 0 to LJsonArray.Count - 1 do
      begin
        LCep := TCepModel.FromJson(LJsonArray.Items[i].ToString);
        Result.Add(LCep);
      end;
    finally
      LJsonArray.Free;
    end;
  except
    Result.Free;
    raise;
  end;
end;

function TCepModel.ToJson: string;
var
  LJsonObj: TJSONObject;
begin
  LJsonObj := TJSONObject.Create;
  try
    LJsonObj.AddPair('cep', Cep);
    LJsonObj.AddPair('logradouro', Logradouro);
    LJsonObj.AddPair('complemento', Complemento);
    LJsonObj.AddPair('bairro', Bairro);
    LJsonObj.AddPair('localidade', Localidade);
    LJsonObj.AddPair('uf', Uf);
    
    Result := LJsonObj.ToString;
  finally
    LJsonObj.Free;
  end;
end;

function TCepModel.ToXml: string;
var
  LXmlDoc: IXMLDocument;
  LNode: IXMLNode;
begin
  LXmlDoc := TXMLDocument.Create(nil);
  try
    LXmlDoc.Active := True;
    LNode := LXmlDoc.AddChild('cep');
    
    LNode.Attributes['cep'] := Cep;
    LNode.Attributes['logradouro'] := Logradouro;
    LNode.Attributes['complemento'] := Complemento;
    LNode.Attributes['bairro'] := Bairro;
    LNode.Attributes['localidade'] := Localidade;
    LNode.Attributes['uf'] := Uf;
    
    Result := LXmlDoc.XML.Text;
  finally
    LXmlDoc.Active := False;
  end;
end;

end. 