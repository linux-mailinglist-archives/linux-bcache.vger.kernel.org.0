Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF786ECC1C
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 14:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbjDXMdY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 08:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjDXMdX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 08:33:23 -0400
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABBC30D7
        for <linux-bcache@vger.kernel.org>; Mon, 24 Apr 2023 05:33:10 -0700 (PDT)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20230424123307epoutp03b4b16fb55a426f4fa5b5e53e325ed77f~Y3vDxZ_212784127841epoutp03B
        for <linux-bcache@vger.kernel.org>; Mon, 24 Apr 2023 12:33:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20230424123307epoutp03b4b16fb55a426f4fa5b5e53e325ed77f~Y3vDxZ_212784127841epoutp03B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1682339587;
        bh=6LtiAqDVhvqj4Zceo1FaUHVR0UivOdGpy/tkN42+w0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iVEHsw0VmrDp76LR9WykfX9vJQx5K4DfbZI0Teqxqz5Qq5f88OzbuD4RwiDY9R9YV
         BMpG58H2VztL+3mGmHMAH+HK4gKBGlCy60x4nOYeHMeAkVZp7vZQWZQmPosReivjAG
         pLwf3zlJetDVBhdUQvJmVv2CDle/KwmzfLfS7WTI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20230424123306epcas5p2a2d87cb75e53d0220d347e4562a37972~Y3vDU6Hg01838718387epcas5p2h;
        Mon, 24 Apr 2023 12:33:06 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.177]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4Q4l0K1rQ7z4x9Pw; Mon, 24 Apr
        2023 12:33:05 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.3D.55646.10776446; Mon, 24 Apr 2023 21:33:05 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
        20230424104340epcas5p16e004dc5fc3cf147b6cdde64085ea6ec~Y2Pfni12I2875628756epcas5p1I;
        Mon, 24 Apr 2023 10:43:40 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20230424104340epsmtrp1e88ce846a961976f4d575da83c1627af~Y2PfmpPG82606426064epsmtrp1l;
        Mon, 24 Apr 2023 10:43:40 +0000 (GMT)
X-AuditID: b6c32a4b-b71fa7000001d95e-1d-644677010477
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        49.E9.27706.B5D56446; Mon, 24 Apr 2023 19:43:39 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20230424104337epsmtip239a08f2be0a1b63630c4dfaf82013362~Y2PdWgrKR1658516585epsmtip22;
        Mon, 24 Apr 2023 10:43:37 +0000 (GMT)
Date:   Mon, 24 Apr 2023 16:10:46 +0530
From:   Nitesh Shetty <nj.shetty@samsung.com>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "josef@toxicpanda.com" <josef@toxicpanda.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "senozhatsky@chromium.org" <senozhatsky@chromium.org>,
        "colyli@suse.de" <colyli@suse.de>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "dlemoal@kernel.org" <dlemoal@kernel.org>,
        "johannes.thumshirn@wdc.com" <johannes.thumshirn@wdc.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "vincent.fu@samsung.com" <vincent.fu@samsung.com>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "shinichiro.kawasaki@wdc.com" <shinichiro.kawasaki@wdc.com>,
        "nbd@other.debian.org" <nbd@other.debian.org>,
        "Jason@zx2c4.com" <Jason@zx2c4.com>
Subject: Re: [PATCH 0/5] block/drivers: don't clear the flag that is not set
Message-ID: <20230424104046.GA17688@green245>
MIME-Version: 1.0
In-Reply-To: <86043b4b-0960-215f-17a7-4c1facdb0713@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJsWRmVeSWpSXmKPExsWy7bCmhi5juVuKwfUP3BavDnQwWqy+289m
        Me3DT2aL9wcfs1pMbzzPbvFgv73Fg6tSFn+77jFZ/HloaHGkqcri2LZrTBZ7b2lbLPv6nt3i
        99O1TBa7Ny5is9g3y9PicXcHo4Ogx+Ur3h6zGy6yeOycdZfd4/LZUo9NqzrZPHqb37F5XP3W
        zOzRt2UVo8fm09UeEzZvZPX4vEnOo/1AN5PH5L9PmQN4o7JtMlITU1KLFFLzkvNTMvPSbZW8
        g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D+UlIoS8wpBQoFJBYXK+nb2RTll5akKmTk
        F5fYKqUWpOQUmBToFSfmFpfmpevlpZZYGRoYGJkCFSZkZzy8llZwgaOipbWRqYGxjb2LkYND
        QsBE4sgL0y5GLg4hgd2MEk+nP2aEcD4xSpw/1ArlfGOU+Lj/FhNMx9JJLBDxvYwS/TcXARVx
        AjnPGCUW/S4CsVkEVCU+bvnKBlLPJqAtcfo/B0hYREBP4uqtG+wgvcwC69gk1k/uAOsVFvCR
        ONf2iR3E5hXQlbj1dB8bhC0ocXLmExYQm1PATuLHhXlgcVEBZYkD244zgdgSAl84JHbeqoew
        XSSeHGuCigtLvDq+hR3ClpJ42d8GZZdLrJyygg3kCAmBFkaJWddnMUIk7CVaT/UzgxzNLJAh
        MW9dAkRYVmLqqXVgM5kF+CR6fz+Bms8rsWMejK0ssWb9AjYIW1Li2vdGNkhYeUjMvywNCZ4X
        jBJvf8lOYJSfheSzWQjLZoEt0JFYsPsTG0RYWmL5Pw4IU1Ni/S79BYysqxglUwuKc9NTi00L
        jPNSy+FRnZyfu4kRnOC1vHcwPnrwQe8QIxMH4yFGCQ5mJRFe4Sy3FCHelMTKqtSi/Pii0pzU
        4kOMpsCImsgsJZqcD8wxeSXxhiaWBiZmZmYmlsZmhkrivOq2J5OFBNITS1KzU1MLUotg+pg4
        OKUamOQyTO2DTqkk2c3r55Sw8V2b+G3DpisKf3bskgs/WOKklf8m4E2g1CLeyhdpPl3cu3tm
        mpjzLFTfG5Ic+dK40P53qFy90xXV02cYRS9Oy1jP+n75Ju6HkooNcqmbmAJ/r/jF/ERBPn31
        KlXeyC5nX8WDth2/bTeaGr4/lcLZaSK1TKDp5K0rKdImVeFMnlvPuro8sb9ufe/j69Szd7N+
        qDvwVr938/i7eXbM+hrrSWbiPY4H5FaLNjL/+j/1Ds/P4ESBMpX2RQtvxm04n2BUeeKf/6bu
        jKTcI4Wv73+zlX+2S1BUIt2nVHmKlOy8ojOmdlcsbzzZoDw70rF8S2nJmu2psxh4p1ud8f3Z
        Xd+jxFKckWioxVxUnAgAg8IEN3kEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsWy7bCSvG50rFuKwaFtVhavDnQwWqy+289m
        Me3DT2aL9wcfs1pMbzzPbvFgv73Fg6tSFn+77jFZ/HloaHGkqcri2LZrTBZ7b2lbLPv6nt3i
        99O1TBa7Ny5is9g3y9PicXcHo4Ogx+Ur3h6zGy6yeOycdZfd4/LZUo9NqzrZPHqb37F5XP3W
        zOzRt2UVo8fm09UeEzZvZPX4vEnOo/1AN5PH5L9PmQN4o7hsUlJzMstSi/TtErgy3v68xlQw
        ga1iz5TV7A2M91m6GDk4JARMJJZOAjK5OIQEdjNKNB96wtbFyAkUl5RY9vcIM4QtLLHy33N2
        iKInjBIbN51mB0mwCKhKfNzylQ1kEJuAtsTp/xwgYREBPYmrt26A1TMLbGOTeLDtB9ggYQEf
        iXNtn8B6eQV0JW493ccGMfQFo0TrzCuMEAlBiZMzn7CA2MwCWhI3/r1kAlnALCAtsfwf2AJO
        ATuJHxfmgR0qKqAscWDbcaYJjIKzkHTPQtI9C6F7ASPzKkbJ1ILi3PTcYsMCw7zUcr3ixNzi
        0rx0veT83E2M4CjV0tzBuH3VB71DjEwcjIcYJTiYlUR4PUqdUoR4UxIrq1KL8uOLSnNSiw8x
        SnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpgEi3a2Lx/883ZZ65slO1P7P19z11XZc7M
        HOtHbAxnrimtSPrL6HcpzHdeUHvA5o/n+ZS9L5cLZwrPXH0u4iy35Lk3jZ3tU77r+Gv7KtTF
        PpZdkr7n1RedmvtxlW3H/zGev/ja9ZJGknlV9FOTV8KPjS/556yU1O3W7LsTdle2u8dPdGbW
        YsYlF0NW7d428bXJ688Oz99/FbMJe2Itq7AoWL+4O0Hoza4rkw6IuicJBuwsXqYy7bHnV6O7
        6Vev81T5/8tRN+R0fnr264O9bx9Y7yt4/mBN7Fa9C+2LqzSKZ7Vcs9mwnMnj9RFPbosYY/3P
        YZMV2mXP9aWdmjCr8aCFrvC5xzuTj/gmvlaT7IiVVGIpzkg01GIuKk4EANc7wnBBAwAA
X-CMS-MailID: 20230424104340epcas5p16e004dc5fc3cf147b6cdde64085ea6ec
X-Msg-Generator: CA
Content-Type: multipart/mixed;
        boundary="----M1XhpxpcEzXMl-TZDJz3dv6uQhpc8LNXMKbaeBmU9jEugurT=_3f4e1_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230424092940epcas5p3407002e7d5c79593ffbafc38f2b49e51
References: <20230424073023.38935-1-kch@nvidia.com>
        <CGME20230424092940epcas5p3407002e7d5c79593ffbafc38f2b49e51@epcas5p3.samsung.com>
        <20230424092641.u6u25eyojewvasj4@green245>
        <86043b4b-0960-215f-17a7-4c1facdb0713@nvidia.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

------M1XhpxpcEzXMl-TZDJz3dv6uQhpc8LNXMKbaeBmU9jEugurT=_3f4e1_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Mon, Apr 24, 2023 at 10:25:34AM +0000, Chaitanya Kulkarni wrote:
> On 4/24/23 02:26, Nitesh Shetty wrote:
> > On 23/04/24 12:30AM, Chaitanya Kulkarni wrote:
> >> null_blk
> >> brd
> >> nbd
> >> zram
> >> bcache
> >
> > Any particular reason for leaving out mtip and s390 drivers ?
> >
> 
> I didn't find why this flag is clear at first place,
> if this gets accepted I'll others gradually..
> 
> > Will it be better to use the flag similar to scsi devices and
> > use it for random number generation ?
> >
> 
> I didn't understand this comment.
> 

My bad. I intended, may be we can set QUEUE_FLAG_ADD_RANDOM flag.
Similar to scsi once the request completes, using function
add_disc_randomness() random generator can be updated.

Regards,
Nitesh Shetty

------M1XhpxpcEzXMl-TZDJz3dv6uQhpc8LNXMKbaeBmU9jEugurT=_3f4e1_
Content-Type: text/plain; charset="utf-8"


------M1XhpxpcEzXMl-TZDJz3dv6uQhpc8LNXMKbaeBmU9jEugurT=_3f4e1_--
