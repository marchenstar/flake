{ ... }:
{
  boot.initrd.systemd.services."unlock-bcachefs-\\x2ebcachefs" = {
    serviceConfig = {
      SetCredentialEncrypted = ''
        password: \
        DHzAexF2RZGcSwvqCLwg/iAAAAABAAAADAAAABAAAAAfvPy5Dz118bYDAUcAAAAAgAAAA \
        AAAAAALACMA8AAAACAAAAAAngAgbookKuuCBzSKm61RZVvyIFe3PTjwvVVH1ceFqu1uHF \
        0AEIb21pfXLnKjOBZjrZu1NhGM9CkVQ4/AbZlpFCVodpQDh2SJGe7vs6acO+GyYosjnNw \
        fMGDwAwCPyKG70syIp/7yZozejxjOyWWfpWnFuAB6lr1qpnSux+qgErVcJc+iuDmyOCZ+ \
        CUxuG6SylCJjpPI6haHLgj4BZ177AE4ACAALAAAEEgAg54MEp8dFPAMLWCZb392ZESNTC \
        enljvSLqUyeceuo+24AEAAgfbixOdI4wo+c/kqpOIjX46gwpVCCeEle1NDcBNF+DNnngw \
        Snx0U8AwtYJlvf3ZkRI1MJ6eWO9IupTJ5x66j7bgAAAACijsptZ0v9SOdMY4sHkNdp/H+ \
        awdj3XbGZzR3fI+Emtj21FkQeZIjsvQAmkSbtnxHghFkynz24jP4zcAWJFw==
      '';
    };
    after = [ "systemd-udev-settle.service" ];
    wants = [ "systemd-udev-settle.service" ];
  };
}
