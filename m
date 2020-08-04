Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E21923BC5C
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Aug 2020 16:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgHDOiC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Aug 2020 10:38:02 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:41487 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728467AbgHDOhz (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Aug 2020 10:37:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596551875; x=1628087875;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=ASKCrUpSqLACIdbyo42p9o4CSArgA6OHoyGCBn3Xin4=;
  b=jZx/w9pah8tlHK5h6c3smFsEKV/K+8NxeNgwW+KchTuIBh00Sslhb+II
   rQvDSI8cL2yyUuDkXsRb26iQPD89emJYI0xd5qHvih+/ZgL5ynTAZ8FpB
   3fPJ4f9xd02xbm7VxqbyXKRgd7j0grF1u2L50EMMoSzdpF/VeB16VcmCJ
   a5QWIrdOqfHnyEFwJjijTFZN8sYas2uO8xx+hyYl61SCmOQBOMQ2eFdQ9
   9iigP4RsKPyIZAI3eUxi2zCtYWBoTu5WLgtdwpeCRz3zUy8SR34sZDLC0
   8u3vvnUBpEJBM6ysrPE4x7qNFBfi0AHQigrWiD4utq8Sijqi5F4R4w2oK
   Q==;
IronPort-SDR: +ac6zVAxS4sYdpP6M8m6MbNnNsTiEMVvfkVPFMEx4FuJGZ85aV6/plvAAhoct7/FsSZ/Q1S4Um
 EhTAhK2qf4V0Vd/qBBkYXpCRKugN73YAmy6/N/NY4jVgQVCbWqdYsDwn+VoEQTj9KTTOWPMVnR
 zRUiptE1nphTyn9AWGiyz1gF3a2WRDruMW8u9rwrDiZmtUiHvOsbUAq0AIYUhjrJNI3yAf7sai
 PnOik+RMd5Xwo38E4Q1CQ3ANTQA8akkDnv6XoRRPgRm1zpHlo+d0mF3AyBP+fmhpxM/jSGFaMy
 9ro=
X-IronPort-AV: E=Sophos;i="5.75,434,1589212800"; 
   d="scan'208";a="145352483"
Received: from mail-dm6nam12lp2169.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.169])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2020 22:37:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hr3ZHBPcc6mIhw6naPG9kXnR/wQxVTwgFSSKtEJ8JHK3DDraeQkqznTAJpEDxbVPRU2jBSLrNWVcwgJ7TD7ZjBOEIA403Uy/Wl3XGh3JrXMWyEEDTKJvnZAg1WokHtZqYxn1Dakwy6cjlB787+3FwH24Eeq82aOjzarseEysA+QBuOkIzgbL4ftfmycU2hFTSVbfeieQsTqpG5uYotQ/yl3Th5Mhnvjj5RP9Vfg1l7b4XbXiuAbSOItGr0XpokPTtO95/xGrdGdnoO1alhhAG4LAd/AbZCcwra7zqUGYw8J1Rwwl9GjuFfWmepfDaQiOS7EMh2cmG3Um3ggRxY1+Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upnVbIkt7/kqwQB/Tz8yJVHhybHEljn5oGOXK7Qgm4A=;
 b=hGxFKo+2fm5DTl8CsJLOPLXZM+WYwU9JDIbtsXlah4Z8p8FsjPMmKsn1OTrfAkys6MgfA2qQMD2w/Dl4PzAqlpElPk4pilrV6+xwSOQPOedUcm7ZrVWOjlLlp3w/09dxsHynwQzGOhjsKKPLOFkiRHcbuK+aaarOZEjx9u6Gf+6HFwHJh55UMVa3jTbSkyJi3GLjJVVY4DmLFIoOrXzoRTTK7lZBdL5A9hxykP+t6Bg0TLf4K2TcIHI4hkFsI7jY1daKCkTqgU9PKtCnWzOsesXovwHfWR6JJtI/NzDtpSGqfIRtrDaVb2oeiwelYu4J3JUj4UJvxlShlY9QSH1BBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upnVbIkt7/kqwQB/Tz8yJVHhybHEljn5oGOXK7Qgm4A=;
 b=TFP3PSHCYEAdow62JFdZi33XH8tqTol2mXARU6aFNWYEd8larD2iHhwIkgNmZaKR5zO3E2bbS/45+Hj434uBwhrYKMe4LHq+X0OZhasTEqgwltpDVEDtAI6XJ0oDqqvJXCdfGKOf/EStfBDiuvSxXlDSeXVT5gISmhmcuCTmX64=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4317.namprd04.prod.outlook.com
 (2603:10b6:805:2f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Tue, 4 Aug
 2020 14:37:50 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.021; Tue, 4 Aug 2020
 14:37:50 +0000
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
Date:   Tue, 4 Aug 2020 14:37:50 +0000
Message-ID: <SN4PR0401MB35983A30C6AE9886EF6E91C79B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200804142332.29961-1-colyli@suse.de>
 <SN4PR0401MB3598033FF16A5AE1D375EDD69B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <b469f0ec-0185-c624-b967-5080d805040c@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 90cdfa28-807e-46d5-35ff-08d83883f710
x-ms-traffictypediagnostic: SN6PR04MB4317:
x-microsoft-antispam-prvs: <SN6PR04MB431713A7EBE4FD9F68D4DB289B4A0@SN6PR04MB4317.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pp3zq2ZnXYl8I1f/yQKt4SlFKsTqLwkKSqaq16UrMYMGEzXjhXPOxuy6MazGmKvZDq6CW2z8v3qBtnHpQqHfw5yM+zFKtBS3I5TUCrs71IxKPu8XOK/LAnewZV9VX6wTpzklwUvnruc5TTGH7KE11ls20/Cd6VHhiFNZuitz3ZKn6vE+AUDyMYtqyCMxdOLLvFlefAYq8wKk75Kwa2xFSPqiD35P3b+e1jw1jV9xt288ZTg8gC2UZm8Cv14FmNeCHs0UfDalP/lKS3G3S2PxeqesAYbPZO7ZcQ+afdnw9+yd7Fhct03oS57BxYAw6FtBN5b03yKXU2Z368pRfMUu0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39850400004)(376002)(366004)(346002)(136003)(316002)(8676002)(71200400001)(4326008)(186003)(8936002)(4744005)(110136005)(26005)(2906002)(66476007)(66446008)(64756008)(66556008)(5660300002)(54906003)(66946007)(33656002)(91956017)(76116006)(478600001)(9686003)(7696005)(7416002)(53546011)(6506007)(52536014)(55016002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: jJH6z8HOx71s/oYWHWArkIaSO1u7/wftbaAaF2Egh5TH114tWCDVFIS3TyUcAeGu1GDMMWewoGzFHBUgGTkkMjrgoWNf6TKGaVw1BSs/3pHH0UQVv01YWZgM0K2z1/xSbKJhc6xPY9swxyRwYQ6kVIDqyUWLVqNt1EaJgmISLMQ4aFaLhOColIrSbGU86vqgjATVh/ItBiYa8sfzgrnGzxKtLAIGji8Zd+Ia3I1KGHZLbXBI6UnfDRT76/yoPe2QS0qY2pkFz/fg4FrqXmU98wnSpMgCZkWUyEx8luccMNen8udSgzRaZz3KGiyukDBp6SBXqkfXHM3V6pexDJP63X3OOlWTyZaH+BER3eY5n12yoqKnicuvq7BDakR+SboUo3bzZMn0IFNyyqDnH6kbLzxObPbAHGMSIr/1eWunwZTmP6LpVV2G2zSQ5Wk7W85YchSxHxIlgmkby5RoBByTtbiVkYuxifMEJeAtv/cbUmBZ1q/I1ZMi//RNHIsCEGuLvipG4gF28emW5JyVyoLurhUbaSbpSu7rU0hMDOCjGWy+7DSdAk3/4bZuaJsR36eFlZoejyFb4Q/afkybyri81K/uKugREtbzILAgKcuUrdDmzpMJDZ1ALxntJSujd9SOiGJw4ZTvnZ711a+b2Dkpbw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90cdfa28-807e-46d5-35ff-08d83883f710
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 14:37:50.8781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B73kpIZoMlzWDt6pSeYrmRvVcObHkW5lvnkgcIeJnzSCY6spaAWcGmM+8HD8p+me7XePAYDJyuU9VYXe8s4n0xvEYJB52BarxR0/jfvTrpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4317
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 04/08/2020 16:34, Coly Li wrote:=0A=
> On 2020/8/4 22:31, Johannes Thumshirn wrote:=0A=
>> On 04/08/2020 16:23, Coly Li wrote:=0A=
>>> This is the procedure to reproduce the panic,=0A=
>>>   # modprobe scsi_debug delay=3D0 dev_size_mb=3D2048 max_queue=3D1=0A=
>>>   # losetup -f /dev/nvme0n1 --direct-io=3Don=0A=
>>>   # blkdiscard /dev/loop0 -o 0 -l 0x200=0A=
>>=0A=
>> losetup -f /dev/sdX isn't it?=0A=
>>=0A=
> =0A=
> In my case, I use a NVMe SSD as the backing device of the loop device.=0A=
> Because I don't have a scsi lun.=0A=
> =0A=
> And loading scsi_debug module seems necessary, otherwise the discard=0A=
> process just hang and I cannot see the kernel panic (I don't know why yet=
).=0A=
=0A=
OK, now that's highly interesting. Does it also happen if you back loop wit=
h=0A=
a file? loop_config_discard() has different cases for the different backing=
 devices/files. S=0A=
