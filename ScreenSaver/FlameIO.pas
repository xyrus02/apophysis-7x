unit FlameIO;

interface

uses
  Controlpoint;

function FlameToXML(const cp1: TControlPoint; sheep: boolean; compact: boolean = false): string;

implementation

uses
  Classes, SysUtils, xForm;

function NumXForms(const cp: TControlPoint): integer;
var
  i: integer;
begin
  Result := NXFORMS;
  for i := 0 to NXFORMS - 1 do begin
    if cp.xform[i].density = 0 then
    begin
      Result := i;
      Break;
    end;
  end;
end;

function CleanXMLName(ident: string): string;
var
  i: integer;
begin
  for i := 0 to Length(ident) do
  begin
    if ident[i] = '*' then
      ident[i] := '_'
    else if ident[i] = '"' then
      ident[i] := #39;
  end;
  Result := ident;
end;


function ColorToXmlCompact(cp1: TControlPoint): string;
var
  i: integer;
begin
  Result := '   <colors count="256" data="';

  for i := 0 to 255 do  begin
    Result := Result + IntToHex(0,2)
                     + IntToHex(cp1.cmap[i, 0],2)
                     + IntToHex(cp1.cmap[i, 1],2)
                     + IntToHex(cp1.cmap[i, 2],2);
  end;
  Result := Result + '"/>';
end;


function ColorToXml(cp1: TControlPoint): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to 255 do  begin
    Result := Result + '   <color index="' + IntToStr(i) +
      '" rgb="' + IntToStr(cp1.cmap[i, 0]) + ' ' +
                  IntToStr(cp1.cmap[i, 1]) + ' ' +
                  IntToStr(cp1.cmap[i, 2]) + '"/>' + #13#10;
  end;
end;


function FlameToXML(const cp1: TControlPoint; sheep: boolean; compact: boolean = false): string;
var
  t, i, j: integer;
  FileList: TStringList;
  x, y, a, b, cc, d, e, f: double;
  varlist, nick, url, pal, hue: string;
begin
  FileList := TStringList.create;
  x := cp1.center[0];
  y := cp1.center[1];
  pal := ''; hue := '';
  if sheep then
  begin
    pal := 'palette="' + IntToStr(cp1.cmapindex) + '" ';
    hue := 'hue="' + format('%g', [cp1.hue_rotation]) + '" ';
  end;
//  if Trim(SheepNick) <> '' then nick := 'nick="' + Trim(SheepNick) + '"';
//  if Trim(SheepURL) <> '' then url := 'url="' + Trim(SheepURL) + '" ';
  try
    FileList.Add('<flame name="' + CleanXMLName(cp1.name) + format('" time="%g" ', [cp1.time]) +
      pal + 'size="' + IntToStr(cp1.width) + ' ' + IntToStr(cp1.height) +
      format('" center="%g %g" ', [x, y]) +
      format('scale="%g" ', [cp1.pixels_per_unit]) +
      format('angle="%g" ', [cp1.FAngle]) +
      format('rotate="%g" ', [-180 * cp1.FAngle/Pi]) +
      format('zoom="%g" ', [cp1.zoom]) +
      'oversample="' + IntToStr(cp1.spatial_oversample) +
      format('" filter="%g" ', [cp1.spatial_filter_radius]) +
      format('quality="%g" ', [cp1.sample_density]) +
      'batches="' + IntToStr(cp1.nbatches) +
      format('" background="%g %g %g" ', [cp1.background[0] / 255, cp1.background[1] / 255, cp1.background[2] / 255]) +
      format('brightness="%g" ', [cp1.brightness]) +
      format('gamma="%g" ', [cp1.gamma]) +
      format('vibrancy="%g" ', [cp1.vibrancy]) + hue + url + nick + '>');
   { Write transform parameters }
    t := NumXForms(cp1);
    for i := 0 to t - 1 do
    begin
      with cp1.xform[i] do
      begin
        a := c[0][0];
        b := c[1][0];
        cc := c[0][1];
        d := c[1][1];
        e := c[2][0];
        f := c[2][1];
        varlist := '';
        for j := 0 to NRVAR - 1 do
        begin
          if vars[j] <> 0 then
          begin
            varlist := varlist + varnames[j] + format('="%f" ', [vars[j]]);
          end;
        end;
        FileList.Add(Format('   <xform weight="%g" color="%g" symmetry="%g" ', [density, color, symmetry]) +
          varlist + Format('coefs="%g %g %g %g %g %g"/>', [a, cc, b, d, e, f]));
      end;
    end;
   { Write palette data }
    if not sheep then begin
      if not compact then
        FileList.Add(ColorToXml(cp1));
      FileList.Add(ColorToXmlcompact(cp1));
   end;

    FileList.Add('</flame>');
    result := FileList.text;
  finally
    FileList.free
  end;
end;

end.
