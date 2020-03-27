Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4452195B04
	for <lists+linux-bcache@lfdr.de>; Fri, 27 Mar 2020 17:24:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgC0QY2 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 27 Mar 2020 12:24:28 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5760 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726333AbgC0QY1 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 27 Mar 2020 12:24:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585326267; x=1616862267;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=XC+2+nAHFK/MUqJ33e//I8PuPgNqQCwZKZ81zGi4Ac8=;
  b=UdA9uwep0knizefuSRZAbtT8YEZjH+KCMYSf5L5/0RGUZ9IgL0lJo0Fd
   OHofZ0UvB53hBzqSL4DzxgXLnWShuI2+5mbl5uM6AjNIQVOa6rw3j+Q37
   MO9gF8EjBX2DnwRPDbGD3P7EtUPd0TfINjYIw/n8+Lr/lGYvLzb7R+O6m
   YLp4FRbLtIqrIU+Y+9MXLxlW1SDxWC/rD/cBeC+KMACg2sl96eHm/6iwc
   SXvsc/5UchqlizZHGwfSUmpgH8MfQk2teCVjeKBVz/OJutK9mcBFM+EoP
   8fl+doYML4knIS0u4q1CLTaJPIPsP2tMABzfq4Xe+BKgzsmUm/6LBM5FS
   Q==;
IronPort-SDR: 0TGXNkorVH83Sac08EyiHkjNr7r6ByATiQVgUMYzubw7EHcQt63g/wn6yeS1iY9RWKPAyJQbDV
 22hDpsbKrGb3N39skNRTkv2+DySP8UifjzCyh1NmwFyEQstAQ4UDyUetGKBOuq40FIgl1ES2xD
 U7rPcSwK488dQNAlUkNCOXpPMZssbeVRjAEYN0r2KIsfYO9SEJ1dlUBfQjGW6o28el8IgBlmcP
 Luhoof13a42reUMhZoewNgEsvw9Tk8bk9HVnbzVknj+KZ9RcwfxONj8E0ty6X9i2kRkjlayA63
 kwY=
X-IronPort-AV: E=Sophos;i="5.72,313,1580745600"; 
   d="scan'208";a="134122072"
Received: from mail-bn3nam04lp2054.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.54])
  by ob1.hgst.iphmx.com with ESMTP; 28 Mar 2020 00:24:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fT16aCZTnSlna7aMUKSuhtUZgESNVJTnMHs20zv8bqyIvOpxlDeXV8daEDUlf32aloJ8AjliiKQMoOYLx1YDnwwhQEuYK/Xqz9u617NnQSP6ilU/Vyhigr+rDdB8bQiSPJTzyV7MFeO85HonOQ9ae8UT+2EJIwznxELiPGQPDZPiDGGjlQt3GKWfsUrfr5yiLRv5tgYuIgQTJP7hi9lkVVw971HptgKG3UCiJrld3wu/sA0YPELxAUw2PCVOrOosu2oKEFrM82rZOfTlu2OkrsHG3pK2uty8nwy5pJhocEv9UkP6tfs8tZEMgQH+9mEdxxWU0O7b7Zkq+50HG24VAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+L8gY9C5dEpvD9LPomjpreto0iQ59pE6XKTIGaAaPtM=;
 b=O4p3wsb5ISrXsR9XjW21Jf8Z5ligtE0czSdzJwGiIXLMDBjgwClmmO7PorQXX7EYrKtluut7GTgCkpqcHjSOmwFo7+YwRPjfbO6eIX4vSDkC9EvxxELid4uSQP/+1xFvnsFuprUGSt7JluMjH0eUj9Yr6yV/a8jYypQ0NjVG0bl+pUjRVYRvSiJSs56nd2sVSYY8xgVmHAo5Og6EMYgdaBmOAjleKxwA/azEF6hg4CXkdbNqbgSlx4w3SmG57Y3tmT1uHxVeqXXXv9nU9P4CI/uO80buNazt3poBnDGI3f/h2c2Azlb8bhKm/RtCD+z+B+Q0CoVnJ+/qZLA6OC29fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+L8gY9C5dEpvD9LPomjpreto0iQ59pE6XKTIGaAaPtM=;
 b=rT3NA9LaqvjVogxg7BYF8m/zbYSbPbAio3ms/mBT6CLipKOaI26nGy8h2tuQT8MrOvnszaLG+2x+H91b1pxNeUghnDz+99gWRIlWLVDuGrfQiLuqIPQTl6xhdGC5KWH/DlVx6cbKg3GaP0aidOFs5GDQm5OdWdf6dofl+02rlhg=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN4PR0401MB3631.namprd04.prod.outlook.com
 (2603:10b6:803:4b::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19; Fri, 27 Mar
 2020 16:24:25 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::9854:2bc6:1ad2:f655%4]) with mapi id 15.20.2856.019; Fri, 27 Mar 2020
 16:24:25 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Christoph Hellwig <hch@lst.de>
CC:     Jens Axboe <axboe@kernel.dk>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Subject: Re: [PATCH 4/5] block: simplify queue allocation
Thread-Topic: [PATCH 4/5] block: simplify queue allocation
Thread-Index: AQHWBBJBOBNuCF+JvkmkSk5kjyZuGQ==
Date:   Fri, 27 Mar 2020 16:24:25 +0000
Message-ID: <SN4PR0401MB3598AD1669D1F5BFCA4F20379BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200327083012.1618778-1-hch@lst.de>
 <20200327083012.1618778-5-hch@lst.de>
 <SN4PR0401MB3598BF20E4DCF8F1B129625E9BCC0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <20200327112131.GA1096@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Johannes.Thumshirn@wdc.com; 
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b5867c7f-e814-472b-9fd4-08d7d26b50ae
x-ms-traffictypediagnostic: SN4PR0401MB3631:
x-microsoft-antispam-prvs: <SN4PR0401MB3631B42FC20D324B666949279BCC0@SN4PR0401MB3631.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:923;
x-forefront-prvs: 0355F3A3AE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(478600001)(5660300002)(66946007)(9686003)(8936002)(4744005)(316002)(186003)(26005)(55016002)(54906003)(33656002)(52536014)(81166006)(2906002)(81156014)(8676002)(6506007)(53546011)(71200400001)(86362001)(64756008)(66556008)(66446008)(66476007)(6916009)(76116006)(91956017)(4326008)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WqD2vG3KjJSDa9pcCaJwypEJoIEqUtxuSCzMIYtOb99EFZNGYVcFlKl+VseNlg938R0QeVPvXvr816czNV54J19e16Xz9D1mfDQ8sBaAE9CDsvMcJpU9QAwyevgrccaMwxp55T3hdByu1Icy7eXqHiAKyPAzA2KtHbC5Rji6OMjxZ91myjVdjVzhkZ8RhiUZaIPchDP/B8dfhKAxT+W1nIlS94alM4RPdYtc1aX5b+CZA2LhN1Q1KlGM0jm/MO5UQ7SMbX3PDrwWrGyfzgX67kxeETRWlxtVVKbf2Ge2vRq1YznIoBngJ9lu/hEwNd4c5GE8XeIl7abNYlBKZoUKj6I7qsTN47ElC+zsmm0DzyrnXFtsz6xtM4hnCF0znLN0J7NdyOfyUu6rhohOb+Q+u1UQUrn1+VyyXY3Z0q8Cn3WaqK9RECacWDeDSO9n+Vum
x-ms-exchange-antispam-messagedata: OdHGKqJpBuh7Fa8cLgy9JrmOFbHEMGL32YgaZ10AYVo7aDcgWBobb5VATun5rctjg9Mt5LZ3ucva90DXiBHh86NqUClKUHTZv7833EpDSyZnl5Gb+BaBD/CHRpHmP8qku/pgUFsDMC3Pydq4u/Ke6Q==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5867c7f-e814-472b-9fd4-08d7d26b50ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2020 16:24:25.2010
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1W593/7KozJbxx7S//ZU5SmSXCq/t++nXZQs7+7+J1AzE3E9cqKYQzU99pFINGyiBsFsH1HNEaFLWzTAkFBfdHU/jXGJD6cd0ogDazxZPo0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR0401MB3631
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 27/03/2020 12:21, Christoph Hellwig wrote:=0A=
> Because the two variants are rather pointless.  And this might get=0A=
> more people to actually pass a useful node ID instead of copy and=0A=
> pasting some old example code. =0A=
=0A=
So then everybody will copy the NUMA_NO_NODE ones and in X years someone =
=0A=
will come up with a wrapper passing in NUMA_NO_NODE to =0A=
blk_alloc_queue_node(), because he/she didn't read the commit history.=0A=
=0A=
But if I'm the only one objecting to it,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
