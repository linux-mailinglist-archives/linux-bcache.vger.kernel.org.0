Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A28256032
	for <lists+linux-bcache@lfdr.de>; Fri, 28 Aug 2020 20:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgH1SBT (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Fri, 28 Aug 2020 14:01:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2526 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726010AbgH1SBP (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Fri, 28 Aug 2020 14:01:15 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07SI0xcM022220;
        Fri, 28 Aug 2020 11:01:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=npal+0BhmmMN5hR+X8cdbdh7b4qEH9vnJZjPALKATOg=;
 b=n2SN5LrKF+LeSzsRznTyvIY03Zt6u1Bf0T7lLHhsG/UgtDSGAXP0cuFs+YfXe7EdJ887
 WwXNQsUZXXeQb4i48EeT2K9y8Dt8+MEksI1xpZWb0/lGc4gRDDVG+5/8bObSefvVe7PI
 nVEuyIq0qeQQzmvh6Qa6iWRfHLNDjpae7GM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 335up8c8cp-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 28 Aug 2020 11:01:01 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 28 Aug 2020 11:00:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bSnYR8suX25SJwXi2pYIXv/0vqPMO9tR+sTXCSi94FAAq89Jkgp8DXxSQjrlzm+0mLhB+8iMyoI6xyu1+JiyxtJ0/xRPNZdx6VUIVh1VwN+CcAgYOwfkpzywLL7vtRxijFqxtuqjhjO+erwMqqpmNmj9D3Eqm1W01GHpXBBs8VChJ4O6BXK2wcQuL2JXuCIP4JbqIhjfAbx6MXLL2Ui7bt7U6285mBUGpLEmJtuD3ZiqeLjNzUqrPpoIa+lUv04HubIKnZPkguGb2CgxTwlwHZFrJf6QSsEHOK+b6JPoZN9yX1lMY11aDnQR6yof0eB5LCvJGXzw5D1RzJmBDvIQfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npal+0BhmmMN5hR+X8cdbdh7b4qEH9vnJZjPALKATOg=;
 b=T28vQFKyHHjy7hjvjH3ukS16LMDr8kFn8ejP+J0LDBxGqgJbov5uvfoWHIk6kNQ5bAIDXPhChy9iZOxTCo0YNsoJrtp7ClOSFJJ5n7EUL7jR0bKBUF2hmcNqeIWC+6UnMxJ0XHDMheZvoUrdOwqXMUXcfD3Ml4LCeA0uVFXsXy2MGE/lFPIp2J8xHvV54S1/HrZCbEIChJD5ursHwIcr9s51hRoteNxV/QWFPGIVdlO+of9EmAYap1oXuEl9W12cJkIYQ2UBTEcB8on001gWHlS6UTfGBoY2ciQiNXsdei3hesrjebmDfuJyKLfq3z4+HJY5cdzRgAG+eQgxB/r7pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=npal+0BhmmMN5hR+X8cdbdh7b4qEH9vnJZjPALKATOg=;
 b=MLYGJa5s8d4vPokOrn8yZEWWAm+SNdE+koFDXvsnwaaySJPc6aHXI6SejU5TaqWAqptjYs5Im+tCo7t89eQ9dGqdO9jDBhLa6X7WPc3ccg+BNbD/onirRpbF67eGEJCwww1wgEbv5Qzeg29bdxfNNpWZvSlw+cT4E4MhYSuQnFY=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2728.namprd15.prod.outlook.com (2603:10b6:a03:14c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.21; Fri, 28 Aug
 2020 18:00:54 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1400:be2f:8b3d:8f4d%7]) with mapi id 15.20.3326.023; Fri, 28 Aug 2020
 18:00:54 +0000
From:   Song Liu <songliubraving@fb.com>
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
CC:     Coly Li <colyli@suse.de>, Jens Axboe <axboe@kernel.dk>,
        Kernel Team <Kernel-team@fb.com>, Song Liu <song@kernel.org>
Subject: Re: [PATCH v2 0/3] block: improve iostat for md/bcache partitions
Thread-Topic: [PATCH v2 0/3] block: improve iostat for md/bcache partitions
Thread-Index: AQHWda67Sg7bLs6JS0apFNQ8Go++eKlN3veA
Date:   Fri, 28 Aug 2020 18:00:53 +0000
Message-ID: <2A15441E-7812-47FA-A3B4-41E8E38AFBC6@fb.com>
References: <20200818222645.952219-1-songliubraving@fb.com>
In-Reply-To: <20200818222645.952219-1-songliubraving@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:858a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf89bb87-d089-4312-4e66-08d84b7c4eba
x-ms-traffictypediagnostic: BYAPR15MB2728:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB27289E870C48096DFD3D5A62B3520@BYAPR15MB2728.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4PwKUzQViTD6sv49EuOH8SAhaVM1SZQXnpZ89jEDW9UPuxF2A1Gx+hU/f+HI7F1a8sOnBdxCMHLwT9E78AmffzP4Nj+yeyp+QcxYDepjSDfPNdm9vcYgFWuY0iVegYo6JN1DPQArzDlfVvHBOVzEw26Zjp5mB6f79UxFcrljENCjnxie0t2bS1lXqpuu5n+9s87xyPM1wPmRk/4simXnqBa/xZebDTsxG6/54ER2ZNoENcWc1EpCGtn8eHPa6YUKi/IeuMkwOaZyb7bENdA/0EIau9wQC74npcB6OqsAwbEcxrVF1R06cs9Zp4aM2517
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(396003)(39860400002)(346002)(376002)(83380400001)(4326008)(2906002)(71200400001)(36756003)(5660300002)(8676002)(316002)(8936002)(66556008)(6486002)(66446008)(64756008)(86362001)(33656002)(66476007)(478600001)(76116006)(186003)(4744005)(6506007)(2616005)(54906003)(6512007)(66946007)(110136005)(53546011);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: L/mGEG2Clu6184z507LIgi6mwOdjj2PzHwSQNPeM3o9FzAlxw1bOhj5APQd9uNg3XkSMSHf9KGu7PDxv/I9h2bkRhzVE5gMdZA7jf/Hqg55SN6mNNdmI69t4pNXd6wNZKWZThrRBQIlLgea+NAkJFECsxBnGwaF9zkwva0JfNAZSCNNDex2wnk0Y9qRfwMcYqC+0Q2DPCp3iBWQ+EN1/vYLhN5RkUS5r9UynJPFACxB5q2F6MjThvEf9ReI1mJq5I9THRmxNgx/p2LzA67AYziDVnTJ8olvI+YELBvqrvnpMv7CpnZZY48gAMxNcLtaIl5/uFwwXBgWHq1HJOuubR16EV/GP+1ZzUE0iNt7wKtx6DgKYRyCITK6IweNfHvJDuywJILtSv1m0WP5TAUQbYcddfQ6nKVQj7XEizuy0B1LumBvlkKEV0Oub/XipQCZ+KE39QuLysgfbL0MT74bAM/QdkjmBNjYMBdDXrDovhb9b1PROOj4LIA5aVOivVUM8xMd/y1TJRxesy9j2Lvf46SEbGNCYSj/xVARgA3owmmPTilkIeNMfHbPbYunAnk3B/wNVpBQLpXD4K3qJuBRwuqZn9DF56Nrjpsis63kBhe0HXsNo0vcJwzX6rhNp74CC1739GEXXg4u9nZ3pq6+eib9gDh8ejETAIP+sDlr0VV7RhJQwP9xRaSJFNC7Dsjxq
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2765C72E873CF47A27E545E9021D7DD@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf89bb87-d089-4312-4e66-08d84b7c4eba
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2020 18:00:54.0066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ZUXsZmOSOUoLc8L27G3FPwBmNhCSX1uhzEAOnqz+yC+JQCzW1+u35jX/g4FVhYE+H6+CuNM2ZyMi9BwnJL6NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2728
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-28_12:2020-08-28,2020-08-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 spamscore=0
 phishscore=0 adultscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=882 lowpriorityscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008280131
X-FB-Internal: deliver
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org



> On Aug 18, 2020, at 3:26 PM, Song Liu <songliubraving@fb.com> wrote:
>=20
> Currently, devices like md, bcache uses disk_[start|end]_io_acct to repor=
t
> iostat. These functions couldn't get proper iostat for partitions on thes=
e
> devices.
>=20
> This set resolves this issue by introducing part_[begin|end]_io_acct, and
> using them in md and bcache code.
>=20
> Changes v1 =3D> v2:
> 1. Refactor the code, as suggested by Christoph.
> 2. Include Coly's Reviewed-by tag.
>=20
> Song Liu (3):
>  block: introduce part_[begin|end]_io_acct
>  md: use part_[begin|end]_io_acct instead of disk_[begin|end]_io_acct
>  bcache: use part_[begin|end]_io_acct instead of
>    disk_[begin|end]_io_acct
>=20
> block/blk-core.c            | 39 +++++++++++++++++++++++++++++++------
> drivers/md/bcache/request.c | 10 ++++++----
> drivers/md/md.c             |  8 ++++----
> include/linux/blkdev.h      |  5 +++++
> 4 files changed, 48 insertions(+), 14 deletions(-)

Hi Christoph,=20

Does this version look good to you?

Thanks,
Song

