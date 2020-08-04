Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB22123BC67
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Aug 2020 16:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgHDOkC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Aug 2020 10:40:02 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:22588 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgHDObj (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Aug 2020 10:31:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596551498; x=1628087498;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=xVTO4E2DeLFFL18io8ffI2xCWzQPL1j2srh5tXQLIOc=;
  b=MTueV8G5sK2meQg7QAZMZ0zRiREnj1bodwfNH2CQGara5VhS4T1KpO8X
   KrkJvLVgUvKWt4fHGKt5h+++It8XkQRiZYvH5p9sj3MRLijDwiRZhbRBU
   +Ga0UxUmeQm9ekHwp6LxNTqF2ZeU1+qbf5pmafkssUPii9FzZJP8kD0jd
   Fs4umb/LSNcGI3z9RsvFNIRpIBFYb3Vxe3bg9rAiy28IBlkBskvGQC0xg
   z8Tyb2gVGSN6N2pQStWMPSa1vvFAJesswq0TBQMbOTs0qENkB2q3f0R7H
   oDr16VTXx6ZSrFxPHC8/MCex90BdtEYm5GXqzxRxLHkPQmMdGg5TjYCC0
   Q==;
IronPort-SDR: Q/Uxq3F88h6Bu4/9ZMzFSWZ82H7xqkI87Kb91RZb6eeKbZYDNWZCv4hlHVtR3zxLs9WDtqzWNb
 dXOLsMkEjMYhVq38h37KbEBZtc89uEBTsfDmlPE030Ht7kxrVbwSmGUL0jkmzVQHcw4uRO+z4S
 2bxu0WpjXUGMDyDZab2GOsqkfl2fq3PNgobnCyvZ/710sF87/AGPNNcNUtyx70NuKrVJp3BR7b
 TWxNmuH/7NW/mxdHM+WJ4XE+dL7r/sWfmaFGrLEb4qlrnN6rzqIlX1Oxno9K2h9etBUoKNX7Os
 vHc=
X-IronPort-AV: E=Sophos;i="5.75,434,1589212800"; 
   d="scan'208";a="144113777"
Received: from mail-co1nam04lp2057.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.57])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2020 22:31:23 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FavUFdW0ah94pxvcK43dZy07P57fvosZFyPbcXSW2feeLH0mtYxCSyoZW35gW+5lQmhBsuH4AAGWgq004Qev0O7oz1JSXB6MpadtkEhlwtrRFOO78NMFgoBqF9SVaJ8Ir0IJvTV3URfKMkGPPBYs2zoDyc0xmHRI1GwwgvXnbigARr4oWS/ZGwzXLypqZ/LRC614DY7MoBXMplDpO++nZc09+fFarN16XyaZLKc7Su5EGjVSAfz8AR2XeVJCAinwS6SLWXIZcEa9e8ikFrjKZEPAqZ7aKxZHWVATB8yTmyQcQPRXUbzHkASMUghTNyBfne3BV1fFJM74WvWHp7xdcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AkZRzzZSN/mpvgprgnj+JoFHNzDKbBaeFVLMud0HAo=;
 b=a4aQ2GzheyhKbEI2XNIzL55Umz3UqlIH14dY12SZLT6As+eucXlP02Gtmna0KiZDrfI6MEZB28e1hMEpfz0i/+zM1kVpQ6PATr6HoqC4ffCPMUcDrXXzlSSfqcxUDS82PF+d+NIxgLGQd/OmrJ6P97Bqre7PNA1Izy9VDthOSwMVa8Z0bAdbXttqr+4T4C3awnzsQ+U1eysVUvPq4dXDSlGXv8XhuCRCze3vLp/F4B81fkBHT71PNss8EyxwYXpcl8AiDEtxTmH8/2ynqigppnKdBapZRgfjGmnHyH9ZPBKgiINIV/o5CBkxjLgD2N4YQ4GYDEtbFRGEdyXixFtyNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5AkZRzzZSN/mpvgprgnj+JoFHNzDKbBaeFVLMud0HAo=;
 b=vrEruOHqF69vknEOy+aZLcLZgBQy9WewDXVdeVQSBz8bqTyQD8cFlX4YaCkOuVJAohsQNMSSVcnD04F3AGS44E+9T8xAdq+geN50DS0RsoVz5CfpEtu0edzsGiH4of21rJz3XzdfUlBrtOgcQtkmSGRuZVn0VAf8b8tyMNoEYMU=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4240.namprd04.prod.outlook.com
 (2603:10b6:805:3c::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.21; Tue, 4 Aug
 2020 14:31:23 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.021; Tue, 4 Aug 2020
 14:31:22 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Coly Li <colyli@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>, Xiao Ni <xni@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Enzo Matsumiya <ematsumiya@suse.com>,
        Jens Axboe <axboe@kernel.dk>, Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH] block: tolerate 0 byte discard_granularity in
 __blkdev_issue_discard()
Thread-Topic: [PATCH] block: tolerate 0 byte discard_granularity in
 __blkdev_issue_discard()
Thread-Index: AQHWamrhOskbhhn9f0O9q4CKi9C/MA==
Date:   Tue, 4 Aug 2020 14:31:22 +0000
Message-ID: <SN4PR0401MB3598033FF16A5AE1D375EDD69B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200804142332.29961-1-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1514c6f4-316a-4c92-5309-08d838830fc8
x-ms-traffictypediagnostic: SN6PR04MB4240:
x-microsoft-antispam-prvs: <SN6PR04MB4240ABFE01C990A3F18E81569B4A0@SN6PR04MB4240.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pTsI48KF0bWGenkInWDzoi7cnEDRjbjlVudwM18IbDliTFIQhfW78v5Uw5KUlYNTJJ1smu6IkTgsq/+NcVgmBG5XKCjRk8AqnEAcdQFVMHKoQ3l+unpPN7kLdywtwb/R1jDalqTeAA+wxDMTcQ8GYFfYV9irUg7A16voSilyXM+1Wc+gQTxVfmGi2WEmdQoOASD7bvzTNUJflbcZwK/aIOsAWWkqkZ81kMZggSmuBuO1g7j/NV1JzR19pdzI2j0lykIE6YYPpcs0T9520LKHdW+q/0dz7v6FxPK+aUHvqWWueenYnDT59/dkqjv2U//R/g/FyihR5zjWAN6V5XuoAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(136003)(39850400004)(366004)(7696005)(6506007)(33656002)(66946007)(64756008)(91956017)(558084003)(66446008)(66476007)(54906003)(66556008)(76116006)(316002)(2906002)(53546011)(86362001)(186003)(110136005)(71200400001)(4326008)(8936002)(7416002)(9686003)(478600001)(52536014)(8676002)(5660300002)(26005)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: +crGDqVdcBJ08VAUVEgsiIl35BDCbPE0ORBV8kDC81NR1HN5QaHmoFOEoYXusAjuscscFXjnQ9LrXzfTiA6JIj5xKeWEAjmcH4AtywIBbSErAqbBCI9VRA2jsyFrpQKUFxikEEaQ5/n9iPd5JKoxW1K7b5UDF7piqtKAr/yFWpe7bUZDuXa8usw1Ixi6aJj8f9/JVHV7kHUZ+ZJ7zTEQDbFSxeM9EwgwXF5vj+z8KRiQyhYC/yOWabBmLlpbDipoUcArTGzqhx7qh7H9m1ShXABWMMEgnHoL8mGzaRQdfjABDgK/o864eLyXJamXRc7hxBG4FmhldJMwPCd25q5XBgpkSSS2YJeF5V8rOICgN/tiSsZEWW0/AFHTczTWNADpaZUDSRBZmu42O0UlcRR44ve+B6vKIVpdIjTbQqs8L6O8uWywEPJsAW4a0oOvo61u5X3sexac8tKiP15Nq4T+rEpwM3YU+eJrxsYfWP8GRt1LigwHZFG6TGWCLuV1bJC9RxWMfbwuGZk7uSWb+2viZOqd6XyylPemu2d16uwcMc5Jqf/PmLv8YdGIasUxUgqxncglHFABDjo3XBaWj53yjoJbEbElTyT1qovzzhvCab92mZ8PPaKNrHY5F2hF1nhPXdvVokrc6A1YXPtq4HnLwA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1514c6f4-316a-4c92-5309-08d838830fc8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 14:31:22.8533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wxfJ1mbyOZTGtsaFRTR6DOZiuNBY6qhv5nqKMMwFSDTxMd77iDz9Hs2bUUkSInsHHuMrG2uxsemVJUOGCsqW+3ZahKaSNqOzJiwZ6bsjwFo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4240
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 04/08/2020 16:23, Coly Li wrote:=0A=
> This is the procedure to reproduce the panic,=0A=
>   # modprobe scsi_debug delay=3D0 dev_size_mb=3D2048 max_queue=3D1=0A=
>   # losetup -f /dev/nvme0n1 --direct-io=3Don=0A=
>   # blkdiscard /dev/loop0 -o 0 -l 0x200=0A=
=0A=
losetup -f /dev/sdX isn't it?=0A=
