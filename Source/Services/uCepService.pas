unit uCepService;

interface

uses
  System.SysUtils, System.Generics.Collections, uCepModel;

type
  ICepService = interface
    ['{12345678-1234-1234-1234-123456789ABC}']
    function ConsultarPorCep(const ACep: string): TCepModel;
    function ConsultarPorEndereco(const AUf, ACidade, ALogradouro: string): TList<TCepModel>;
  end;

implementation

end. 