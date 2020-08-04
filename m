Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D9723BC6B
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Aug 2020 16:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729131AbgHDOkI (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Aug 2020 10:40:08 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:23291 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728157AbgHDOkA (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Aug 2020 10:40:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596551999; x=1628087999;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=wbf025ctdBheET/PwuKdmRItCq6BInNbJnhEPqQTi1g=;
  b=CcMOtnK5UENI+qXLI87gCnlX2ZzsPyWPrjWIjSdQCPtz8kqZ/JIzwToV
   9cSSOl6lHzAwAv77G7Itsaa394kQlIiR3SMDAeKutUtSprp9MtRHLSD5E
   QgZ8kBZyw8FZhwBwFyp2fm5S4AmTt/eL7XhQ/dPGxtwLlAVhlH31ZM7dG
   DoY6Egfc6QsUXX4EDIMjaJRF2xwZZGB7VattvwF4hriQBAxTDiHxJK36Z
   0WOrCsdnPv3FMpqR+JzU1pabLGM+h+Q9ipwrnTG4iCTHw2iBsGw6hzify
   jKMBnuHN/BdwWrVMj/T7eJXkq9kdLVgO/V8Jz7mfmJ5B8AP+8I85ehRoI
   A==;
IronPort-SDR: NNRzA7xpwhK+sSZfroOiSR5AKwcGYTN/55aqyQghOeQZHOIFLGay/KRfOM04nYhcLKaFwmSAFP
 UhAfD2do47NmjrDq+sNbSmfbR8YNzb60Hbq+62xqFp5rL5oyw3wr6j97UwrLyA19kSTU/8BaG7
 OZ8Mk9vH2ei7TOWoWZHTqet1hQNzupzjg6k/BZsLTaHF5j/rjpzG0yg0dAGBPJwvRudzzEdjUN
 d4u0R+DzWVYsMkbbB+RapK7Q3VfREeFmti1Zh5vSzGHPqeKfVpkF7VvlwV63o3VwlP3AtrbAtT
 6SU=
X-IronPort-AV: E=Sophos;i="5.75,434,1589212800"; 
   d="scan'208";a="144114634"
Received: from mail-bn8nam12lp2170.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.170])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2020 22:39:58 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZDTbPq75/gbLJKsemQbpsV9PU+/7u82g6ZEBD6SDVVvN5O4mfl0iPje62N7HFjfTXjpzQjRoboGyb+okcVRF/cayJB/goDB5JpyveRaqGAwOM87XNhpd8wW3t17pkMr4h6j7TS77Kaka77cXORuKzostBkpD23+Se8f8jFJse6uSYMQo1ievbIMrBvStfGtZH9wlb5uKcwibUtVdoHPlI40k9MhdYmePCwkaSNMZLzBAbmgs2DMX+u5ORXapuWxLhPPuDSaMf93PZ4U1fn9ZDEVIMcARMLD8imux0bT6VELwu6LwvNpx9tYlLVZKiMHXTXIpaQpmKoyuIaIIRawzJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8gkZtgQGVsA1iIp87w4FQ5oBwuqqXhY6pyQFOm99MI=;
 b=PoI/VSQCWVKsWyvW80h9EAV7/IoWFUxxvMVkC1ow9cejWUBKEvziTm5fFNMRtpEdHZNFG8g7ITxK4YVY9O0nMxlq+cMhRSeh0w/K9tRqCEVC/z0NiM7+w2MbJSL4DxvTYG7JDHiUpMbCfFy+WwV+hHdrp+saRZzSch9YmTtT1JmZsBCM6kfeFHsIUOYWWYObNmPmB0yUWAz1AyC1AqjR5Uqpo2LKY1wg+wrkJKt7v/fMo/R+ZZqStn9wmIklGpaw4ROHLC1hmOB9aYTwtVRWSNkfUQTDWPNzmXUZBZXuzg2pUzFtVGBcPS8a4O0o5K5b3q10VjIZjGDeaMedCeEKQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8gkZtgQGVsA1iIp87w4FQ5oBwuqqXhY6pyQFOm99MI=;
 b=O5c+3376cQN8FTb9zMzoZegclppUtGYQqFYDF4DuNotvbZ6dilLV0DA3aVBBvtxsSfJCoUfnf1zeE6h7mnSSTa4TEy+H2BEGbYXFg7AEdUvpMkUwvff0pTrUsJQJzqeREI8MgWyWUXzw6+cNGLIa7lStd3jE+ZSKKDTHopHFSOM=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4317.namprd04.prod.outlook.com
 (2603:10b6:805:2f::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Tue, 4 Aug
 2020 14:39:57 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.021; Tue, 4 Aug 2020
 14:39:57 +0000
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
Date:   Tue, 4 Aug 2020 14:39:56 +0000
Message-ID: <SN4PR0401MB35984D6090CE1B7F1FD06CD59B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200804142332.29961-1-colyli@suse.de>
 <SN4PR0401MB3598033FF16A5AE1D375EDD69B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <b469f0ec-0185-c624-b967-5080d805040c@suse.de>
 <SN4PR0401MB35983A30C6AE9886EF6E91C79B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9febf1dc-02be-4aca-a42f-08d83884422e
x-ms-traffictypediagnostic: SN6PR04MB4317:
x-microsoft-antispam-prvs: <SN6PR04MB43177100A2710B02F71741DE9B4A0@SN6PR04MB4317.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0hgLKaoWCWT16nQSoKktfbam6SZaqLZIq2uH2lbhGthH5IwmtF5BKTXU0xxVrL/fuacSdtJgIuIA3pxJXlRQolF4fRVTsL6A3kCypq/WXcUMkrl6pbh8Gn85DPOsxL0m7hDJymGGVnYaeQhgeAEPfO86H8Xot69qb/A2y0ymZtECoEyleKpQ4mNjTouK2E8b1fbsmiPE5b7STgAPHIQWB6+SDVV+lBt734/PknyjslBaWQOOn7OfY46FVGMHJGyITQazjG1XmRQNhupZ/dUyzbu0AlbsCF7hxbeTVDuO2Z9CCHUn09IEfISDa7xsfB4hxW54/8VuvS6Zp9ZUxOLJNw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39850400004)(376002)(366004)(346002)(136003)(316002)(8676002)(71200400001)(4326008)(186003)(8936002)(110136005)(26005)(2906002)(66476007)(66446008)(64756008)(66556008)(5660300002)(54906003)(66946007)(33656002)(91956017)(76116006)(478600001)(9686003)(7696005)(7416002)(53546011)(6506007)(52536014)(55016002)(86362001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: r0hIx4idDr6qxRgYgYrn7qp/SAZ+Ehl+7//bysL0dNtDSGGEUa0M/FAjorKT4Rt/pjPiwZ86DanXmPAhoWpqVblJZ4eHvi3sAkU1tuWL18tCJjRxe3GS7CAfiTJ906FTEZ4v0VHXgsDFtFplSU2Tq11VxLJyqXUjUaFB6Ji4zTLZmBS+JvDCWXpp3kR66TkbSOUeLDa/dLnpZmVDxL+c291djGTTsgqhhiXfnXSdKCa7hyRV6o9ij7Z7qokzs5Q9TKUjWFdwPQO7FB+Ap3GUyP88dB+Uxi4R51YRB6K2wiQORvq+PCMRyuqFOykLdoKZnslMeLOkiP0R0JJx8NIsgU40ZCDXuTD2wpEwiIfeB/gTzOYXvCum95u6iMUtuQf+wqe2ZsJI5HXgBNgZl2CMFEF/dnza7wCnR5v8CZdub/2C7n7sSQi5CI/g0q1Hk5+5CH2ijCEYlQhqkZM80dgSZP9F/j7Arla92koH9q8FAiPw/jMPxhnSDZqjUFu/TSL3ZY8dz/DuRT3B3F1nsm9pgKDWWR28i3V3w1Vyohh7N19Ai4ck9B7W2U9aAhmi9FBxbohVuFDAiHK8NM7fqwP3FlbIRou0YZEwcPd2LIoBustiMLlKuRD9MMsu0YABhywYAy3nq2S+DBiBkeF2qxAfjg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9febf1dc-02be-4aca-a42f-08d83884422e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 14:39:56.8987
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LDMw2OUG3dRA3e7UzNzq+SoOeze1lICK9vz2EAub4yFBagesN8yFrnF3TgUKTC3k6UKD20c7U2IAreNqADJFZPRIRpdoiPoR2l4muxifARE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4317
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 04/08/2020 16:37, Johannes Thumshirn wrote:=0A=
> On 04/08/2020 16:34, Coly Li wrote:=0A=
>> On 2020/8/4 22:31, Johannes Thumshirn wrote:=0A=
>>> On 04/08/2020 16:23, Coly Li wrote:=0A=
>>>> This is the procedure to reproduce the panic,=0A=
>>>>   # modprobe scsi_debug delay=3D0 dev_size_mb=3D2048 max_queue=3D1=0A=
>>>>   # losetup -f /dev/nvme0n1 --direct-io=3Don=0A=
>>>>   # blkdiscard /dev/loop0 -o 0 -l 0x200=0A=
>>>=0A=
>>> losetup -f /dev/sdX isn't it?=0A=
>>>=0A=
>>=0A=
>> In my case, I use a NVMe SSD as the backing device of the loop device.=
=0A=
>> Because I don't have a scsi lun.=0A=
>>=0A=
>> And loading scsi_debug module seems necessary, otherwise the discard=0A=
>> process just hang and I cannot see the kernel panic (I don't know why ye=
t).=0A=
> =0A=
> OK, now that's highly interesting. Does it also happen if you back loop w=
ith=0A=
> a file? loop_config_discard() has different cases for the different backi=
ng devices/files. S=0A=
> =0A=
=0A=
Damn I didn't want to hit sent....=0A=
=0A=
Does this (untested) change make a difference:=0A=
=0A=
diff --git a/drivers/block/loop.c b/drivers/block/loop.c=0A=
index 475e1a738560..8a07a89d702e 100644=0A=
--- a/drivers/block/loop.c=0A=
+++ b/drivers/block/loop.c=0A=
@@ -895,6 +895,9 @@ static void loop_config_discard(struct loop_device *lo)=
=0A=
                blk_queue_max_write_zeroes_sectors(q,=0A=
                        backingq->limits.max_write_zeroes_sectors);=0A=
 =0A=
+               q->limits.discard_granularity =3D=0A=
+                       backingq->limits.discard_granularity;=0A=
+=0A=
        /*=0A=
         * We use punch hole to reclaim the free space used by the=0A=
         * image a.k.a. discard. However we do not support discard if=0A=
=0A=
