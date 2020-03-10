Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B24E4180C34
	for <lists+linux-bcache@lfdr.de>; Wed, 11 Mar 2020 00:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgCJXTC (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 10 Mar 2020 19:19:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54252 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727484AbgCJXTB (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 10 Mar 2020 19:19:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583882340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z5sLqw2q00TFWFE2+/xEamSW6/qGE1IWWYINTtiDzeQ=;
        b=Rj9QDPftG/jz8cX7UbkFeEOEWSvdFLVrqeckBoauoZfVexbVFpwONB822wfPDG9ULf7hJN
        jz45ilvD3F674oUyLCiS9cfdeQPCTegMs3S//3j5dM7qlLiR5PQSu+gdFA9Pzk6cfi+zO0
        w1/lK0m8RPrjDsrNqO/ApJd46OoxXYI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-HUChE5yDMLeAPXsxm1X5YQ-1; Tue, 10 Mar 2020 19:18:58 -0400
X-MC-Unique: HUChE5yDMLeAPXsxm1X5YQ-1
Received: by mail-ed1-f70.google.com with SMTP id y23so203536edt.2
        for <linux-bcache@vger.kernel.org>; Tue, 10 Mar 2020 16:18:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z5sLqw2q00TFWFE2+/xEamSW6/qGE1IWWYINTtiDzeQ=;
        b=lbzfDlDSYYh2bphxnFU1SwuvmlmN2rEob3E9CTMx4shpF8+ZAdYD99zhCOGnE+ozuY
         ugRxwrkQlUkD6UJosglOejOZD74gR9FrCuoAB4fq8RuQDfAER+PKZO9Td7FHxgqV4SoA
         lbE5aMmwTJliM+QRsZ3jID7KTu205MjcCmxuUaiJ9l4qOvpO4+/04Zw5t2BEBKwZI9sl
         cY7F0HivvmAn0UEqD0cBv26tYTxL5rzHlo42K4m5okg1HUSP3DxZp65Pnw9XqRkGE9um
         wuHAhFk913kRpiHcHOlPUnUqnSP4KB5ywFBXNoTjMQwWR4BFkoejfZ28SinDup02URU4
         wmCQ==
X-Gm-Message-State: ANhLgQ3Ej5lPXf7eaKLve4HN9TQ4nLpE1+TZW7LN2L9r7CLZ6cTUwAii
        KAgOevLCES3Jau5pJNPTgD1KUfl7tUoxXBiSuUsh/84v37zPTO/orumqeuEXRP7/UACPmyNn04J
        WZFK/B4zqidIB0moLQlQEUBxp/adE0WfUgh1YJchR
X-Received: by 2002:a17:907:262a:: with SMTP id aq10mr12415665ejc.377.1583882337420;
        Tue, 10 Mar 2020 16:18:57 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vstjHqiZOF0xElis+31S7G0gY2aH73JLw/AluJvKeWmdJcJyHfoWoeERc+w0Ht0pyWZgseKXsqtbLAkFkQLxyM=
X-Received: by 2002:a17:907:262a:: with SMTP id aq10mr12415648ejc.377.1583882337100;
 Tue, 10 Mar 2020 16:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200310223516.102758-1-mcroce@redhat.com> <d473061b-688f-f4a6-c0e8-61c22b8a2b10@cloud.ionos.com>
In-Reply-To: <d473061b-688f-f4a6-c0e8-61c22b8a2b10@cloud.ionos.com>
From:   Matteo Croce <mcroce@redhat.com>
Date:   Wed, 11 Mar 2020 00:18:21 +0100
Message-ID: <CAGnkfhwjXN_T09MsD1e6P95gUqxCbWL7BcOLSy16_QOZsZKbgQ@mail.gmail.com>
Subject: Re: [PATCH v2] block: refactor duplicated macros
To:     Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc:     linux-block@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-nvdimm <linux-nvdimm@lists.01.org>,
        linux-bcache@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-mmc@vger.kernel.org,
        xen-devel <xen-devel@lists.xenproject.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-nfs@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Wed, Mar 11, 2020 at 12:10 AM Guoqing Jiang
<guoqing.jiang@cloud.ionos.com> wrote:
>
>
>
> On 3/10/20 11:35 PM, Matteo Croce wrote:
> > +++ b/drivers/md/raid1.c
> > @@ -2129,7 +2129,7 @@ static void process_checks(struct r1bio *r1_bio)
> >       int vcnt;
> >
> >       /* Fix variable parts of all bios */
> > -     vcnt = (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT - 9);
> > +     vcnt = (r1_bio->sectors + PAGE_SECTORS - 1) >> (PAGE_SHIFT - 9);
>
> Maybe replace "PAGE_SHIFT - 9" with "PAGE_SECTORS_SHIFT" too.
>
> Thanks,
> Guoqing
>

Wow, there are a lot of them!

$ git grep -c 'PAGE_SHIFT - 9'
arch/ia64/include/asm/pgtable.h:2
block/blk-settings.c:2
block/partition-generic.c:1
drivers/md/dm-table.c:1
drivers/md/raid1.c:1
drivers/md/raid10.c:1
drivers/md/raid5-cache.c:5
drivers/md/raid5.h:1
drivers/nvme/host/fc.c:1
drivers/nvme/target/loop.c:1
fs/erofs/internal.h:1
fs/ext2/dir.c:1
fs/libfs.c:1
fs/nilfs2/dir.c:1
mm/page_io.c:2
mm/swapfile.c:6

-- 
Matteo Croce
per aspera ad upstream

