import 'package:spotapi/model/spot.dart';
import 'package:spotapi/spotapi.dart';

enum DepartementEnum {
  pasDeCalais,
  somme,
  seineMaritime,
  eure,
  calvados,
  manche,
  illeEtVilaine,
  cotesDArmor,
  finistere,
  morbihan,
  loireAtlantique,
  vendee,
  charenteMaritime,
  gironde,
  landes,
  pyreneeAtlantique,
  pyreneeOrientale,
  aude,
  herault,
  gard,
  boucheDuRhone,
  vars,
  alpesMaritimes,
  hautCorse,
  corseSud,
  guadeloupe,
  martinique,
  guyane,
  mayote,
  reunion,
  saintPierreEtMiquelon
}

class Departement extends ManagedObject<_Departement> implements _Departement {

  static String nameFromEnum(DepartementEnum departement) {
    switch(departement) {
      case DepartementEnum.pasDeCalais:
        return "Pas de Calais";
        break;
      case DepartementEnum.somme:
        return "Somme";
        break;
      case DepartementEnum.seineMaritime:
        return "Seine Maritime";
        break;
      case DepartementEnum.eure:
        return "Eure";
        break;
      case DepartementEnum.calvados:
        return "Calvados";
        break;
      case DepartementEnum.manche:
        return "Manche";
        break;
      case DepartementEnum.illeEtVilaine:
        return "Ille et Vilaine";
        break;
      case DepartementEnum.cotesDArmor:
        return "Côtes d'Armor";
        break;
      case DepartementEnum.finistere:
        return "Finistére";
        break;
      case DepartementEnum.morbihan:
        return "Morbihan";
        break;
      case DepartementEnum.loireAtlantique:
        return "Loire Atlantique";
        break;
      case DepartementEnum.vendee:
        return "Vendée";
        break;
      case DepartementEnum.charenteMaritime:
        return "Charente Maritime";
        break;
      case DepartementEnum.gironde:
        return "Gironde";
        break;
      case DepartementEnum.landes:
        return "Landes";
        break;
      case DepartementEnum.pyreneeAtlantique:
        return "Pyrenée Atlantique";
        break;
      case DepartementEnum.pyreneeOrientale:
        return "Pyrenée Orientale";
        break;
      case DepartementEnum.aude:
        return "Aude";
        break;
      case DepartementEnum.herault:
        return "Herault";
        break;
      case DepartementEnum.gard:
        return "Gard";
        break;
      case DepartementEnum.boucheDuRhone:
        return "Bouche du Rhone";
        break;
      case DepartementEnum.vars:
        return "Vars";
        break;
      case DepartementEnum.alpesMaritimes:
        return "Alpes Maritimes";
        break;
      case DepartementEnum.hautCorse:
        return "Haut Corse";
        break;
      case DepartementEnum.corseSud:
        return "Corse Sud ";
        break;
      case DepartementEnum.guadeloupe:
        return "Guadeloupe";
        break;
      case DepartementEnum.martinique:
        return "Martinique";
        break;
      case DepartementEnum.guyane:
        return "Guyane";
        break;
      case DepartementEnum.mayote:
        return "Mayote";
        break;
      case DepartementEnum.reunion:
        return "Réunion";
        break;
      case DepartementEnum.saintPierreEtMiquelon:
        return "Saint Pierre et Miquelon";
        break;
      default:
        return "";
        break;
    }
  }

  static String numberFromDepartement(DepartementEnum departement) {
    switch(departement) {
      case DepartementEnum.pasDeCalais:
        return "62";
        break;
      case DepartementEnum.somme:
        return "80";
        break;
      case DepartementEnum.seineMaritime:
        return "76";
        break;
      case DepartementEnum.eure:
        return "27";
        break;
      case DepartementEnum.calvados:
        return "14";
        break;
      case DepartementEnum.manche:
        return "50";
        break;
      case DepartementEnum.illeEtVilaine:
        return "35";
        break;
      case DepartementEnum.cotesDArmor:
        return "22";
        break;
      case DepartementEnum.finistere:
        return "29";
        break;
      case DepartementEnum.morbihan:
        return "56";
        break;
      case DepartementEnum.loireAtlantique:
        return "44";
        break;
      case DepartementEnum.vendee:
        return "85";
        break;
      case DepartementEnum.charenteMaritime:
        return "17";
        break;
      case DepartementEnum.gironde:
        return "33";
        break;
      case DepartementEnum.landes:
        return "40";
        break;
      case DepartementEnum.pyreneeAtlantique:
        return "64";
        break;
      case DepartementEnum.pyreneeOrientale:
        return "66";
        break;
      case DepartementEnum.aude:
        return "11";
        break;
      case DepartementEnum.herault:
        return "34";
        break;
      case DepartementEnum.gard:
        return "30";
        break;
      case DepartementEnum.boucheDuRhone:
        return "13";
        break;
      case DepartementEnum.vars:
        return "83";
        break;
      case DepartementEnum.alpesMaritimes:
        return "6";
        break;
      case DepartementEnum.hautCorse:
        return "2B";
        break;
      case DepartementEnum.corseSud:
        return "2A";
        break;
      case DepartementEnum.guadeloupe:
        return "971";
        break;
      case DepartementEnum.martinique:
        return "972";
        break;
      case DepartementEnum.guyane:
        return "973";
        break;
      case DepartementEnum.mayote:
        return "976";
        break;
      case DepartementEnum.reunion:
        return "974";
        break;
      case DepartementEnum.saintPierreEtMiquelon:
        return "975";
        break;
      default:
        return "0";
    }
  }
}

class _Departement {
  @primaryKey
  int id;

  @Column(indexed: true, nullable: false)
  DepartementEnum departement;

  ManagedSet<Spot> spots;
}