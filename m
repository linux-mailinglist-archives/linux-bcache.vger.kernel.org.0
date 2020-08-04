Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1B5123BCB7
	for <lists+linux-bcache@lfdr.de>; Tue,  4 Aug 2020 16:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgHDOy3 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 4 Aug 2020 10:54:29 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:37233 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgHDOy2 (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 4 Aug 2020 10:54:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1596552868; x=1628088868;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=oBmB+KbnN9te0+ZhbNiFw4mufdWr9aEZt25QI9icg30=;
  b=Bgca/p+AGgQCYZTL2B53FSq29ijRNqSil0WHj4EgpYwZ5KPfrmm4PbNJ
   0tJbp96UxtwORyB28d17zzMMtQUFH31/4XLG7J/wEI8wN9mxLs02tLKf6
   lSm8rzVsuRtHGnsH/HAtDBuf/VJ5vkrajAl9edRxVoOBij+UO0cd8Gw/k
   BWzxyLMl/pxGDGhyKbtdgF2lPMX7Lg5+uJTe2PMn1f6/NOveReh5pIM/k
   ZPjDJqT9MOGUJLU2Tx94YWbR8VxcOHAT6RnLQIrLWMzIiNws7v2Ebz0aP
   ZSNBNeT3ZVh25q/O8dmUyKyjAnp4lhM9PqQgoMyFQ4vV9q0Af886wzHSc
   A==;
IronPort-SDR: kSzQegDvEUyvOSuzDXO0VwTHbNuJ7at1CtkUxz12GVToFWPbmKjXOkAGCxh9JifytoUtJaRRRA
 hCPVra3+dZqUiiQsV5tHRMLBZEY8qOuH+QHCZpx+zFCz55js7ir12c0UIZ7RXwzymduspKVS5d
 tg+O4MSgpQOp/JqGgt3sA14PvkSs2iPXjvf7PMo1eN/2R0OLnjwyprovd6axoA7qnqc9Qii53Q
 Hfy8eUt0NBk2MRw1qGiVdEpYyQ2o30zJuE2Rvx3kE9HJsvlvByJrokbnZhGy6McI5OpEmrdRr5
 sLE=
X-IronPort-AV: E=Sophos;i="5.75,434,1589212800"; 
   d="scan'208";a="144186195"
Received: from mail-sn1nam04lp2058.outbound.protection.outlook.com (HELO NAM04-SN1-obe.outbound.protection.outlook.com) ([104.47.44.58])
  by ob1.hgst.iphmx.com with ESMTP; 04 Aug 2020 22:54:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cLPvcfyTKqdQtSXMXV3iU9sC3bLQD/bIVbS1985XLZ/wwaZ4YRalpOTexfHaV+Owlc/RjgQrBv2CNtsEDa/VTQuxrqaWq1GfadF2YxzEzM+Lvha+THTs4shYDw19x4dm5a03qM4anY72LwOvZtloY4nTBezYIYNrVir09Q1uqZZgLuBwTEi3NM8ED8ypCTkVf5bs0JGJLsYmKqKZrJrP9vmzju/P6/ZURCV6Q+wJZSjzOvTrposW8r65wQHVdTRELe97KFBSGD4w0kkfkLYnIzs/b6PR4KpSJgf/Bf7PBPzymNYKUr4lf5CLARlXBN3RcFu9OeWK+SooVbbdmYcngA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBmB+KbnN9te0+ZhbNiFw4mufdWr9aEZt25QI9icg30=;
 b=SFHrEads4x248tEuzncIJPCBdiXywCiU3G9bBxQMogyeLbyZLxibghV3aNvHY2WH28Jy0b1Qu4D1aOHTsbvbo9xYmZaYwGiHxF/lBLorcjL46lMivajuuLAVYo5QL13TYgOm20n5a3phfQNs6aWmvfMVqcXZ5zwoP/qfLX774lkDauA7OzzDPh2TRHmbmCQ1/zwaHxkRtS+8p38r6XY/DRsb02y8L7i+TwAYbu6DlOEk5lWp3ECNv3xPL8JuH7Ut4gsQeazntjOGgBNl/bmmnkyPvIj/Fi2HDu/t1frokNPYpuYL+gilOklBFgBAXWQSX8zffA8mMxJSzxuFd9UClQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oBmB+KbnN9te0+ZhbNiFw4mufdWr9aEZt25QI9icg30=;
 b=qKOsLRZ2QdBcvsKIK9mqb7M6wwWvF7KK8RcU8BN8KrY4NoXdHtMlSAppBJMXJ+fEd+sYtFUaOohh/Q1HrF2zy09BZH06xsocRbQUGu2VQNTir56Zs64WMqnTA55RdSJcq2gyzzsOMEB9bl7SZjqQSWqkAYVmWPD9NlybeJNn7sU=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4861.namprd04.prod.outlook.com
 (2603:10b6:805:94::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Tue, 4 Aug
 2020 14:54:25 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::457e:5fe9:2ae3:e738%7]) with mapi id 15.20.3239.021; Tue, 4 Aug 2020
 14:54:25 +0000
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
Date:   Tue, 4 Aug 2020 14:54:25 +0000
Message-ID: <SN4PR0401MB35987148438CF84C015CCC479B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200804142332.29961-1-colyli@suse.de>
 <SN4PR0401MB3598033FF16A5AE1D375EDD69B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <b469f0ec-0185-c624-b967-5080d805040c@suse.de>
 <SN4PR0401MB35983A30C6AE9886EF6E91C79B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <SN4PR0401MB35984D6090CE1B7F1FD06CD59B4A0@SN4PR0401MB3598.namprd04.prod.outlook.com>
 <06f2bb53-8917-82d6-3e0c-76270cd80e06@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9b0fcee3-99bf-47ec-82b1-08d8388647d3
x-ms-traffictypediagnostic: SN6PR04MB4861:
x-microsoft-antispam-prvs: <SN6PR04MB486176D44BD2321680C2A04C9B4A0@SN6PR04MB4861.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f7MT0K1fApDFW2Zuhgcbe7ByA0WDzx6EcBURM2rSXx2fQ/APu16zUbu91JvfsrzumWVqP3APZDo6k1EIImyy7LUN3nlemtFFdLfC/5IydXeT0AX3BuNmMieShmQ+NaH//+DLn1fRS9B3j5Bp6eq3j8ZDR2K5WMQzzo9M8vM6MDAXiUkrRNxFqGSbunCV5xLYuBu+nZY+VmIu4VIAGb30SQFCifTeCVGr1XRjLdWYKimmQB7w4Yi7zelc71h3XcGWnahH4QUfPRzY8c1EwHK+feBj7P5AsWeqlVcHqXAXRh0Ctxl+IZw4lCftRmM4w5nveZouoaK649fIAGDUZ/aRhw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39850400004)(366004)(376002)(346002)(558084003)(91956017)(76116006)(5660300002)(52536014)(4326008)(54906003)(316002)(66476007)(66556008)(110136005)(66446008)(64756008)(66946007)(8936002)(55016002)(53546011)(2906002)(26005)(186003)(8676002)(6506007)(86362001)(71200400001)(33656002)(7696005)(7416002)(9686003)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 1VGo4yvvi4FHBihiyWLLedFkqk+zDtp7a46b4FDfnw3+ukk6ojQn1xuzj0TpRQDmUOdtiF5dKH2g2oZceHudLwrbRPutqpz1ac5/UrzQTKZAM22v+h2ip3lsSO9WEiwXlN/mOEWy5/coGMMAede60jSA9g2uswKZFKQg3Uige5XJJRxIhoffXX0NgUke/QU6lC+SyLkEpQsmU+SAF2OFvqofYzAfY/lOvASI/gxzJsbnMb2xxqFpusxykB/JHmxm32LqnLs2gF/KRVc7Ep808AFN0d5viAC95h+vhds289bjYdy/jZSYHkMjq/3iGWFnusEEEXq8Dum6+RcvKTdmdOsU26OYWvvmNvCl4LQsc0e3cMjn/ZqDeZcGnsKitOx9+8twcI4DXkFZ3vwi4X691noGZilzRxL2tuSOxCrHwQpSO3GbfaihQTSP/LuLo0sv2r07LXOLtzPGnLjU8ew3QizZxbJgr12P5jV57hTRMAVpm+zP5CjmfzF66vxzKP+y2BoY9GNbuGcld7fzPoKbNGYY74Q/Etxe2t9e2VxSD+UOIsQDXLP2j9TrjxR+AvrqSQsTACj50/Pmzc/Etc3uKE1F4W5NUsW7gJocc97GeGVZLxKtM/x1o1HGONByUnPgxwv9mLZsQknF0yDxV/HfKA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b0fcee3-99bf-47ec-82b1-08d8388647d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2020 14:54:25.3672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sLwgJVdEvzvaZuEomntmvCF6VLn10YIeE13KO79IaefADWTs1YtGQxsZUp+0nLyzD3HNh3dFZiVUJA/06osl14wP1EwCCiqjbXRn6elmel0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4861
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 04/08/2020 16:45, Coly Li wrote:=0A=
> Yes, Ming just posts a patch with a very similar change to loop device=0A=
> driver.=0A=
=0A=
Ah ok. I'll go and have a look at Ming's patch then.=0A=
