Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E167848623A
	for <lists+linux-bcache@lfdr.de>; Thu,  6 Jan 2022 10:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237471AbiAFJk7 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 6 Jan 2022 04:40:59 -0500
Received: from mail3.siteparc.fr ([158.255.101.105]:56762 "EHLO
        mail3.siteparc.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237477AbiAFJk6 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 6 Jan 2022 04:40:58 -0500
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2022 04:40:58 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ellis.siteparc.fr; s=8d899c83d57de82;
        h=x-mailer:to:references:message-id:content-transfer-encoding:cc
          :date:in-reply-to:from:subject:mime-version:content-type;
        bh=fmChc7M6YZ39FFYvkcIWf8R6MxM12dh9LtfouFfJgH8=;
        b=EtwKwrVCrNz7aCy+1vvIFRUVm+lCbIt/LA3mCE/ZC/AzVLmwDqXBraQyqyxLYd4Aw
          6JwCcttrJcW/ehrguDwi8DKh5jeTtiMgzoQTd/dmcz3YbjJu3B86g9anceHOv5200
          QHmZI/BOr7yHoLTp0lbGCeVPzbQ12OFG32zTp47etcl1kOnYVpD0dnMnqF7Pe35gC
          UxSj8QXQKyDsOlPIuQLH3eY3v7ZjD2OIEOCBm5285y4IIH8MtVgBmb+x5iitMek4R
          JSRlZ0GEgKiI0muGvmqJMdqzISaXhFwKJvsRvsPlIUJP4g9lMSeE+uUFKT87JtbQr
          Hy0fuYcdy9SJpmUVw==
Received: from [172.24.1.32] (UnknownHost [31.179.160.58]) by mail3.siteparc.fr with SMTP
        (version=Tls12
        cipher=Aes256 bits=256);
   Thu, 6 Jan 2022 10:25:38 +0100
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.21\))
Subject: Re: Consistent failure of bcache upgrading from 5.10 to 5.15.2
From:   =?utf-8?Q?Fr=C3=A9d=C3=A9ric_Dumas?= <f.dumas@ellis.siteparc.fr>
In-Reply-To: <431f7be3-3b72-110-692c-ca8a11265d3@ewheeler.net>
Date:   Thu, 6 Jan 2022 11:25:33 +0200
Cc:     Coly Li <colyli@suse.de>, Eric Wheeler <bcache@lists.ewheeler.net>,
        Kai Krakow <kai@kaishome.de>,
        Kent Overstreet <kent.overstreet@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7212111D-5181-458B-B774-006D3B08A9AE@ellis.siteparc.fr>
References: <CAC2ZOYtu65fxz6yez4H2iX=_mCs6QDonzKy7_O70jTEED7kqRQ@mail.gmail.com>
 <7485d9b0-80f4-4fff-5a0c-6dd0c35ff91b@suse.de>
 <CAC2ZOYsoZJ2_73ZBfN13txs0=zqMVcjqDMMjmiWCq=kE8sprcw@mail.gmail.com>
 <688136f0-78a9-cf1f-cc68-928c4316c81b@bcache.ewheeler.net>
 <8e25f190-c712-0244-3bfd-65f1d7c7df33@suse.de>
 <431f7be3-3b72-110-692c-ca8a11265d3@ewheeler.net>
To:     linux-bcache@vger.kernel.org
X-Mailer: Apple Mail (2.3445.104.21)
X-Exim-Id: 7212111D-5181-458B-B774-006D3B08A9AE
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org


Hello!

Many thanks to Eric for describing here and in his previous email the =
bug I experienced using bcache on SSDs formatted as 4k sectors. Thanks =
also to him for explaining to me that all I had to do was reformat the =
SSDs into 512-byte sectors to easily get around the bug.


> I'm not sure how to format it 4k, but this is how Fr=C3=A9d=C3=A9ric =
set it to 512=20
> bytes and fixed his issue:
>=20
> # intelmas start -intelssd 0 -nvmeformat LBAFormat=3D0


Right.
To format an Intel NVMe P3700 back to 4k sectors, the command is as =
follows:

# intelmas start -intelssd 0 -nvmeformat LBAFormat=3D3


> The parameter LBAformat specifies the sector size to set. Valid =
options are in the range from index 0 to the number of supported LBA =
formats of the NVMe drive, however the only sector sizes supported in =
Intel=C2=AE NVMe drives are 512B and 4096B which corresponds to indexes =
0 and 3 respectively.


Source: =
https://www.intel.com/content/www/us/en/support/articles/000057964/memory-=
and-storage.html

Oddly enough the user manual for the intelmass application [1] (formerly =
isdct) forgets to specify the possible values to be given to the =
LBAformat argument, which makes it much less useful. :-)


Regards,

Fr=C3=A9d=C3=A9ric.


[1] =
https://www.intel.com/content/www/us/en/download/19520/intel-memory-and-st=
orage-tool-cli-command-line-interface.html
--
Fr=C3=A9d=C3=A9ric Dumas
f.dumas@ellis.siteparc.fr



