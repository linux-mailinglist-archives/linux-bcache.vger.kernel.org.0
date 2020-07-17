Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0303E2235E1
	for <lists+linux-bcache@lfdr.de>; Fri, 17 Jul 2020 09:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbgGQH2D (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 17 Jul 2020 03:28:03 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:63468 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgGQH2D (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 17 Jul 2020 03:28:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594970882; x=1626506882;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
  b=X0tfi44kB5GV06w9SPoMiZ27l6RMi8slldR5En9BY7xeFU9ZzT+fRAtQ
   ryH5FmnMlx6XdqKRYWWaqAqitR4NHcpxFuBIOmcH91L6NMHT5y0NLjXLE
   4MUzh2gYDBT2ulVzMzjGmr7tSeB3uI3/4VO9JgzKYknh70qvCdcR5vVzx
   Ib3TxJNYoqyQW5H6ljJFe9yaLOkV33IdhRCw/AHMw8+r77+pgt7wQ38zH
   TR/BCQB7S/TqcmqIHTHBbSwnpB+CUhNu90Ey8xwzHB+UY7KJKgKw+as03
   TzjyqSxU3udJ9tdV/ZKXzWLhtl7O9oSi+OsWYjwPP2CA3clkgQk/73yT3
   Q==;
IronPort-SDR: /1/XPmS0Oa2Vyq2wtsYF6L3V0kQ7YLKum06QmSGRJH0K/K4cqAHUlKLeJlxn3O/08xQyZ5h9zz
 PDUuALmoP7WQ35fv19SkfOSUkmT6NwgX6OKimCtr7F+KiqJL+KzqYHjomYRTRxfRXdYw8kSly5
 ffI3uGxJqNEGHZt8Rq7ZqUGqK659G0g19UzZOtt59VWoEaVp1LMlz2eWfW8czJrRX+SiJ4d1uy
 SRlGQgV+aO85+8UrvoowX8tmPWXTikA7YMYM3pusY8nfDf5pdgSQyHoBOo7+eZmg0j2qHFSeyi
 62Y=
X-IronPort-AV: E=Sophos;i="5.75,362,1589212800"; 
   d="scan'208";a="251958869"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jul 2020 15:27:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MSs9aSourhHz7qhaPWRdHwgZy2244o5SHqp/vyvnUGed715H8bp1vbjJR8n7sPJy4wdjDdsKGE65z7uL7+WPjTToS07HB5mA4UDhEcCFQdicTpHKL4gbynCOkta9rkG2G+W1ZxTkl8OrXAd2/XZbnyVTQGmHy3/Lmv79Xcyz3arDvehoX/VKTaPSreswTMXfnG51ux6uFaSxyVsjrvmBP0GmW9dU6SLVDsWV9IUs9Mk6+uafZ9jboGKbT4wGWwPi2A5Ra+oj4BfDiujCp4jqmX8DmHuZ9SVT3wAAZRzOXgmKyqqKLRhUKgVc3FQnzduzD9gHUAdCvEUK0NFvbsgUTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=LjUG+y3epF22+qV5NCWsMi43xoAISKnlP0IsxqIJJR+tlI2QchLCvTGc9eA+OB4gzb4VvUhmoPvKzfn7RzMUnM9jeJo1v8r3ACPPQNtP4qii4ditagZp0dxqZ61OxOgwov29lhzIocxGIXZhW0KQWDnBrfY8ud0i1nh1TycuzYBbTFo0E3R1+XRyJsb2NL5v2F0AJ0l0FNRYuwFDVXYKI+g76PExNzNxrIUiRas0A7z/zDMn1pumjxROX6qOsFzmBTxn2xyDJckiYw2FgVZi4oSCz757kjzXzmvgvACGB3O0iprHiUhCHeCMaHk5hiPNo5zNS4MATpv8DneVMZoZuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8FZ0D3PP/OudJ5uuxCAz/C/vBHo8wESZoPwxTWqVEI=;
 b=uX6kg7Vqus29/M1q8std8xCedNYoecnQNS6vNWtSwHfseD3kjexgGYcI5R6C6kYK/s3bokoC4W7s0LWANarT3/uppuYg2eXr6NN6djP12PVsBpdCgxsyLnA/ubx8tmSuod2HCASptgbI/kMK+XkHvGus98OhWn57B4xufmPWQ2E=
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 (2603:10b6:803:47::21) by SN6PR04MB4781.namprd04.prod.outlook.com
 (2603:10b6:805:b2::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 17 Jul
 2020 07:27:57 +0000
Received: from SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2]) by SN4PR0401MB3598.namprd04.prod.outlook.com
 ([fe80::1447:186c:326e:30b2%7]) with mapi id 15.20.3174.026; Fri, 17 Jul 2020
 07:27:57 +0000
From:   Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To:     Coly Li <colyli@suse.de>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
CC:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jens Axboe <axboe@fb.com>, Keith Busch <kbusch@kernel.org>,
        Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v3 1/2] block: change REQ_OP_ZONE_RESET and
 REQ_OP_ZONE_RESET_ALL to be odd numbers
Thread-Topic: [PATCH v3 1/2] block: change REQ_OP_ZONE_RESET and
 REQ_OP_ZONE_RESET_ALL to be odd numbers
Thread-Index: AQHWW+P7Ckpen/iNokK53B+SzMnOQA==
Date:   Fri, 17 Jul 2020 07:27:57 +0000
Message-ID: <SN4PR0401MB359887E0A0E7C9DA01184C349B7C0@SN4PR0401MB3598.namprd04.prod.outlook.com>
References: <20200717024230.33116-1-colyli@suse.de>
 <20200717024230.33116-2-colyli@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [129.253.240.72]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 96ee41e0-2e71-4a3b-d17b-08d82a22eda1
x-ms-traffictypediagnostic: SN6PR04MB4781:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR04MB47810DFF3C60C1FE3B98B73B9B7C0@SN6PR04MB4781.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: s5dNxC3gKN4QlNfF5ufFS36veh/7RnB0OMw2HUlPB/5P2OZJh18yCugFCb7tpcb6bdL7PHgBrdcimctuOwXm4JT8/aCRZUDVbi85IGrhK8RzOpsfJ0WDnUYMP8dcBtWqt/FXAYMpfWEuCUcIM13+Yq8izVWVvuLF6AdSGt2j80t9d8AX1jsxYT9rw5/kq2bf/HD0WtqCroVjyxtxkEZnUMcB4HVxbTCDSDkFnSNH6D/EkvEnV+SS+cKrrAkVKhx4hWd/KQ3HuPYrEHMNcrClCTSVghZe0r91iw+IiQLB69UhX7N6bb+nrvN1Y5uGPkae4plw3Heb6PsxLLSEkKAk6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR0401MB3598.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39860400002)(136003)(346002)(396003)(26005)(9686003)(6506007)(52536014)(5660300002)(66556008)(64756008)(66446008)(66476007)(66946007)(2906002)(7416002)(55016002)(316002)(54906003)(8676002)(110136005)(478600001)(71200400001)(4326008)(33656002)(7696005)(4270600006)(558084003)(19618925003)(91956017)(76116006)(8936002)(86362001)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: CiAnjEtnCpr57QZX/YP4sTOYs25+DZcDol0ySEv0WDJDFWzLx4EGOH0rTbwzKkHUCbcKOfbbH+/7pt6NpYnLPf1WlcQAOZEviBQn740Sdt+/FGNIFzvvoOOIYjRlHMX6uR/OlqxO2DZ2J7T2s1hGM1megFhsNFQ7pu/MF5bt/TIFsJXA581lF+aDTi7GNKr+QfJRctaqRnlMpuTMxRa67zoW3hbb5LdTh/SdJ7VU6MY/m9w3HDkrWP6AYM0aHSPUoL7Rwt775XGVxpwjf8rNFVbAor0nnzAWKharLEqYnHZgou06ljZ4ENnNRaXHTtTOk/ri4oJ3RgLRShBVk8CR9HJjpy6rJN3PDtxK570hYgkiwOn8qXaBoLFH9TMf+FK49b3ItD6u8XraazGt/tAI0i7z1Rbf4BUVaaZ/1tNOQPbX6lrKlDBENUsaWEt6sHsGvoZB/M9n1/01v5DKy26iVq7+0yz/v9Z2UFJZgd4ppsletmq28ScpkH6/del+2wVB
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN4PR0401MB3598.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96ee41e0-2e71-4a3b-d17b-08d82a22eda1
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2020 07:27:57.5385
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: H5WOF1PIZZCH0ubzOduIhDI8GGrkGRO59C3zQaijZGxlGff1lz9hemWlk9ITaG//30lZkZlHeoIGtG91Zjf/+dfGn63e7P/an0qCopqbTYw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4781
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Looks good,=0A=
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>=0A=
