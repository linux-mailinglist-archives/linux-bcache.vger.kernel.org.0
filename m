Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD4D1D715F
	for <lists+linux-bcache@lfdr.de>; Mon, 18 May 2020 08:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgERG4k (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 18 May 2020 02:56:40 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:26324 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgERG4j (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 18 May 2020 02:56:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1589784999; x=1621320999;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=qrILgPvcViNNX8QECg5QCcAXIwLK/mZaof1IMas/FVw=;
  b=Z5qrYZlzhAMooDa0ACQlo9O8io82TpyJykv/LVBDFSN1c5QbvxDm/Hi0
   sxrrolaCGeBP/JtkF2O7UPXCZARsq44KrWdVfu350ipH0AXokBL4sm1Ib
   /VdP1KeibfD6FwH2/UI+1deSSdzpo+fPevfdrTupWxr7UsEKx42P5Rkj/
   wPPLlvDpTVvDAmdLwKrC2r6aFB7f49fDrYzzm5u12wge1hYWV/xO/xHAr
   jDknif2DbMZTr2+Do8HucSRTsPNaboPDPiC98IAYkYgu+tYy/w02kH8Uo
   DynKPrytHFHBrODYNn/eTQgXHUp0ZDXvMqLvDAsgjZte6N1Tcz5Vt0DpL
   g==;
IronPort-SDR: M6IrnpCBbOsvGKXn+PDLj/8WVeHsJTSUxjUTj8s2vO6Dcqv1nhrvphlFM/Z3NLr9iz1twWgrd2
 Yv48pT2x7EaSJq8vNFdiebp/rxJWuDVJAN14JKoOINViyIuAIc+5VeG0xK5cdrjl9Uyzei8sN6
 afm3QJtYZQWYeWxD8L7LBzWZEN51EmjbaJq81QnpEbbKLglx1mVCxXpN27F6imzkArOf0ddpQk
 rBZTAwwGtjd5N0YrP4lE1i2kYi+pdKB6JD5C/VrKIMGnoAaq/wCVeztxvCZHd3o7G/0dpPFlz9
 teY=
X-IronPort-AV: E=Sophos;i="5.73,406,1583164800"; 
   d="scan'208";a="246907201"
Received: from mail-bn7nam10lp2108.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.108])
  by ob1.hgst.iphmx.com with ESMTP; 18 May 2020 14:56:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pbo1qlrrTYzHaRV7qxETfVrzl6jxve1Lq5VTntwKU47iqTUEUbGZ/4siTZ376Zhg1Y+GjU7PTbtGMKhrAXnUqwOyydOUJ+E+/EzZQkyaoo9V/Ns19ti15REztE/6rBcJab5f50x1xZIjFv6y/K+0ZUYu+TQ32VsSNlDg3K2uxq/Da0gV2GKDHmeMJnVUtnsoop37xT/vn/cvxTkXbm5NBHzy0/D4clOlF0wa+kyIKlcmv04+q0zMYAW1Gn/mHYR2L2D8icFikpRgTYBBtbsoA0lo+Ndw0Yhq1sIOn5g3kb39m0+DiEW0BXwKMptnfMyGe2YsSdC80l48sgL0qNB/FA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PZQ95CWQtGDbMFy92cPICr4e6rXtV0rqTz3k1D0DGc=;
 b=hOLMcWtrSHfsY3zCzV7FH6BpceP04Mx44s7GLCwrkiFq1t0MqD2gw7kmAadd5kRjK9Caw9+fLukKDihO+sYAhZcFzB4eVQIzFVHHqNugz95FSUmy9++6ccjjk8eXgAq9zy9iZypT1vuaZKMFJ8/1Sc6iZc/qNHBA/mzcXs3xsEBXbF3PjOVLZ/chesztv2JZV7Tu296L028CgSD3fpLIcBDUszd3Y02VMV4LngWaKgA4SAiOyLdkd3cXJ+qOI0Qfkbll4ugSp9aK3LhOTI2zKGfhRSC+w9HQSp6/HVDnCGnTuiRGoSAo1l+awy0L+QZI1q32sGDjTNm+fafFRtdVYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4PZQ95CWQtGDbMFy92cPICr4e6rXtV0rqTz3k1D0DGc=;
 b=e3qlhuXQRXB9SyMbrBKO9eud1eFu5jbuZ8z7U+M149bzH70lpVkN7QPk+XhRTAa+DzrC90M4ifM8pd53HQgGUUnUPKqsVKetDh5OUQww/uGoERBTMd3NfWSg0jtw60ikdGvqaho05fXiFsaFNpZ6aq2fy0Hh1jEAjoeJcxiYvAs=
Received: from BY5PR04MB6900.namprd04.prod.outlook.com (2603:10b6:a03:229::20)
 by BY5PR04MB6721.namprd04.prod.outlook.com (2603:10b6:a03:22a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.25; Mon, 18 May
 2020 06:56:36 +0000
Received: from BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606]) by BY5PR04MB6900.namprd04.prod.outlook.com
 ([fe80::b574:3071:da2f:7606%6]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 06:56:36 +0000
From:   Damien Le Moal <Damien.LeMoal@wdc.com>
To:     Hannes Reinecke <hare@suse.de>, Coly Li <colyli@suse.de>,
        Christoph Hellwig <hch@lst.de>
CC:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "kbusch@kernel.org" <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Thread-Topic: [RFC PATCH v2 1/4] block: change REQ_OP_ZONE_RESET from 6 to 13
Thread-Index: AQHWKzXNZ12ghqAt20GTR1GjD4GRxw==
Date:   Mon, 18 May 2020 06:56:36 +0000
Message-ID: <BY5PR04MB6900419B7FBB5913904B3AF1E7B80@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200516035434.82809-1-colyli@suse.de>
 <20200516035434.82809-2-colyli@suse.de> <20200516123801.GB13448@lst.de>
 <fc0fd3c9-ea46-7c62-2a57-abd64e79cd08@suse.de>
 <20200516125027.GA13730@lst.de>
 <f57da1e7-1563-db1e-8730-8daca219cbe7@suse.de>
 <20200516153649.GB16693@lst.de>
 <c50be737-da25-1e48-3e26-aa15df175110@suse.de>
 <19eea726-590c-bf55-2dbf-35b71c9d1600@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.182.57]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 14a8d2d4-f9dc-41ed-07c7-08d7faf89b73
x-ms-traffictypediagnostic: BY5PR04MB6721:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB672199B042F8C101D90010B4E7B80@BY5PR04MB6721.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IW96HI7kEHCdeTpPd/5qGYhDJCIPRuuhriEC+PvtYZklDvnVWsidJDE71mx3snGFdqm249psXf20C+SN8Egduidz7qkwCwowv7clh7jo/4HL7LjHNRQkVGsw/jLTCjhtgnhV71auBvAqx5CpkWDC4pzDSPLKUk3rqFVFqEC2cCvcU/kUIK8UM04GsBtvuW5OJj6pQ2yHxW9caXNrJlvI9716dYil77mIH/Ur8g2MIx7bFzZx0/qdtYpUfWai28Bl8SqRUQVp/eTN+WnaiGpao2kjQ4w6eIXrWMHWAjPK1HTq7r5KuvFHfO/Jm9PEKB9Vzv+roNOiV2saO155MxqaxDKfja+ZRTGsaCtXk22AIDysdxz2UBKcRIIqkObQHZeTmrptm1vwu+q5UY79+F6yo1wZUCzo/If7xcE9ysGdQ2Uv565LcifxllMMiDmIcYZg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR04MB6900.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(26005)(9686003)(52536014)(55016002)(186003)(33656002)(8936002)(66946007)(53546011)(76116006)(66556008)(66476007)(6506007)(8676002)(64756008)(66446008)(316002)(110136005)(7696005)(71200400001)(54906003)(4326008)(478600001)(86362001)(2906002)(7416002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: K3YB3zLEHFe8Bi40fy4kszw9/1WIZ28d/V3W45WpbdwJaak4Xo5LmQ9mGtyjkBlToJFDJmQmLTA8jAMSWVmZliTZlNwPuqG3ShND5e6F2Uno3NhvB2pcHY3E/qxy3+Vnw8T5xvNvzF29Q72nfsnW1xtw8oIeW+JBsmbRBvvbxTktwgPtQKBhK+8qAOxRtElSJSfyyKLThdyowjFftt1BdX5iTLGKPr6rbIrK1IXpTOk7BRMfEAjRqOfn3zi/9RvmZIdJ5mryd+9lZqi90POxB8rOiSyBdTaXnxYuV/UOCI0TtLaUaRKNezQnNwGBLy2jLmaPXKxvFE3jHvd5OpYnFZRfWRow3niWDTMXhj82EajvaC/O8RylQBdzSivYuAvhi+rD888JEkCIe/TjLla5xriH6NwsgtdtVhUFRh3fw95UjAJgQgPvEHEZg5Nhpz5CsFOBsxRVovzakeQz8/1Ndd+bCRvAShUM+6zzE+iCpqurS7NVhU+tAWOIf0ivpLLw
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a8d2d4-f9dc-41ed-07c7-08d7faf89b73
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 06:56:36.0944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tI3ZPczK/4gGLhRFfdbVz9bDi64UCQAxEuV7YO/WTsUtJrIKRIZOvDOTp/u0C2KrrkelhczpUcx4KE27Xr2AnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6721
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/05/18 15:53, Hannes Reinecke wrote:=0A=
> On 5/17/20 7:30 AM, Coly Li wrote:=0A=
>> On 2020/5/16 23:36, Christoph Hellwig wrote:=0A=
>>> On Sat, May 16, 2020 at 09:05:39PM +0800, Coly Li wrote:=0A=
>>>> On 2020/5/16 20:50, Christoph Hellwig wrote:=0A=
>>>>> On Sat, May 16, 2020 at 08:44:45PM +0800, Coly Li wrote:=0A=
>>>>>> Yes you are right, just like REQ_OP_DISCARD which does not transfer =
any=0A=
>>>>>> data but changes the data on device. If the request changes the stor=
ed=0A=
>>>>>> data, it does transfer data.=0A=
>>>>>=0A=
>>>>> REQ_OP_DISCARD is a special case, because most implementation end up=
=0A=
>>>>> transferring data, it just gets attached in the low-level driver.=0A=
>>>>>=0A=
>>>>=0A=
>>>> Yes, REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL are quite similar to=
=0A=
>>>> REQ_OP_DISCARD. Data read from the LBA range of reset zone is not=0A=
>>>> suggested and the content is undefined.=0A=
>>>>=0A=
>>>> For bcache, similar to REQ_OP_DISCARD, REQ_OP_ZONE_RESET and=0A=
>>>> REQ_OP_ZONE_RESET_ALL are handled in same way: If the backing device=
=0A=
>>>> supports discard/zone_reset, and the operation successes, then cached=
=0A=
>>>> data on SSD covered by the LBA range should be invalid, otherwise user=
s=0A=
>>>> will read outdated and garbage data.=0A=
>>>>=0A=
>>>> We should treat REQ_OP_ZONE_RESET and REQ_OP_ZONE_RESET_ALL being in=
=0A=
>>>> WRITE direction.=0A=
>>>=0A=
>>> No, the difference is that the underlying SCSI/ATA/NVMe command tend to=
=0A=
>>> usually actually transfer data.  Take a look at the special_vec field=
=0A=
>>> in struct request and the RQF_SPECIAL_PAYLOAD flag.=0A=
>>>=0A=
>>=0A=
>> Then bio_data_dir() will be problematic, as it is defined,=0A=
>>   52 /*=0A=
>>   53  * Return the data direction, READ or WRITE.=0A=
>>   54  */=0A=
>>   55 #define bio_data_dir(bio) \=0A=
>>   56         (op_is_write(bio_op(bio)) ? WRITE : READ)=0A=
>>=0A=
>> For the REQ_OP_ZONE_RESET bio, bio_data_dir() will report it as READ.=0A=
>>=0A=
>> Since the author is you, how to fix this ?=0A=
>>=0A=
> =0A=
> Well, but I do think that Coly is right in that bio_data_dir() is very =
=0A=
> unconvincing, or at least improperly documented.=0A=
> =0A=
> I can't quite follow Christoph's argument in that bio_data_dir() =0A=
> reflects whether data is _actually_ transferred (if so, why would =0A=
> REQ_OP_ZONE_CLOSE() be marked as WRITE?)=0A=
> However, in most cases bio_data_dir() will only come into effect if =0A=
> there are attached bvecs.=0A=
> =0A=
> So the _correct_ usage for bio_data_dir() would be to check if there is =
=0A=
> data attached to the bio (eg by using bio_has_data()), and only call =0A=
> bio_data_dir() if that returns true. For false you'd need to add a =0A=
> switch evaluating the individual commands.=0A=
> =0A=
> And, btw, bio_has_data() needs updating, too; all the zone commands are =
=0A=
> missing from there, too.=0A=
=0A=
Not really. They all have 0 size, so bio_has_data() always return false for=
 zone=0A=
management ops. It will return true only for report zones.=0A=
=0A=
> =0A=
> Cheers,=0A=
> =0A=
> Hannes=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
