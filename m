Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3B95DDBE
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jul 2019 07:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfGCFZc (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Jul 2019 01:25:32 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33448 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfGCFZc (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Jul 2019 01:25:32 -0400
Received: by mail-pl1-f193.google.com with SMTP id c14so572452plo.0;
        Tue, 02 Jul 2019 22:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r6I6wc5B3tGetonqRKuXvbIfduj5xwDTVPvTS3gafAE=;
        b=CZQNmmjFRPz2c0ELVDfpA3j7aSVWE+5Qg1vfMOIG2VWjD9mJh1UaZP7ZQpUm45tT4I
         G89/bEHPJDS+5bqZxR0gWH9CPLadIBhjLBtmwSVbNDQlvJJw4w4R+QnuH1Lm+6sibJvt
         VWMU5qjzV4ZMyNpb71v+K4HBk94SUBZnTTJoTAt55EZg7HnXciFXunOBa93B+dqEOrNC
         OVYuwGlsRiBHK07HQd8UIz35gbq+0al/pZfht/zKee9EjcZw9py+3HkGQ8SQ+fNzrxnk
         Lt5R8PzTiN5nfhRKdxyySR177s69/YA/ZQt9f+kD1Gfw9Ouh3SKlNCp85vmzYGaek7Ha
         cb7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=r6I6wc5B3tGetonqRKuXvbIfduj5xwDTVPvTS3gafAE=;
        b=DKlcwppa34IhGRzUecf4liXoMTzW6SCtjk6LmPvZLHQ4GhK9gWduSPZi2huCDTd3O/
         yBjdxlUsrNQFsEduoy9dCtAeedX7DeQkFKj5ZPyl92xYroOXZjqWMNcisg180zM1KuzM
         xmtHdDk825E7/nFFeC+hMxlm9/FmQnN9UD5xGNINfRwcdQOmGq9SNLk03AiBZF5PyKms
         vZQsPfNFso+Tvm2b6J/ppjMmMP6+bys8mjjYSSvIODmD+oei+U883Gwbr8fj3poSAeGf
         sRSLJ/AX8eMevYf/U0VpOyWBeIpw71eHtJLEfcEY4w7KrWyLFkONEMUNdNdnH27Lx2JR
         PF0w==
X-Gm-Message-State: APjAAAVBVw3Un3/AO3MoVLRm59jbyK5x0Er5eZq9okhkl11SDfBH0P3c
        qU7/NrwzS9+oO/6+I8VOz5Y=
X-Google-Smtp-Source: APXvYqyh2xiiI7N7Hxwuc+2RWnCTE22iy7sXtxhYXynsUmnx/rtn6Fz0u+M/S3UPLVrtIJWjrgu02g==
X-Received: by 2002:a17:902:a612:: with SMTP id u18mr38729348plq.181.1562131531447;
        Tue, 02 Jul 2019 22:25:31 -0700 (PDT)
Received: from localhost ([123.213.206.190])
        by smtp.gmail.com with ESMTPSA id h14sm770155pgn.51.2019.07.02.22.25.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 22:25:30 -0700 (PDT)
Date:   Wed, 3 Jul 2019 14:25:28 +0900
From:   Minwoo Im <minwoo.im.dev@gmail.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "colyli@suse.de" <colyli@suse.de>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-btrace@vger.kernel.org" <linux-btrace@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "kent.overstreet@gmail.com" <kent.overstreet@gmail.com>,
        "yuchao0@huawei.com" <yuchao0@huawei.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 4/9] blk-zoned: update blkdev_reset_zones() with helper
Message-ID: <20190703052528.GB21258@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
 <20190703002347.GE15705@minwoo-desktop>
 <DM6PR04MB5754D27FC41D86E2D419DD6C86FB0@DM6PR04MB5754.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <DM6PR04MB5754D27FC41D86E2D419DD6C86FB0@DM6PR04MB5754.namprd04.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 19-07-03 02:29:33, Chaitanya Kulkarni wrote:
> On 7/2/19 5:23 PM, Minwoo Im wrote:
> > On 19-07-02 10:42:30, Chaitanya Kulkarni wrote:
> >> This patch updates the blkdev_reset_zones() with newly introduced
> >> helper function to read the nr_sects from block device's hd_parts with
> >> the help of part_nr_sects_read().
> > Chaitanya,
> >
> > Are the first three patches split for a special reason?  IMHO, it could
> > be squashed into a single one.
> >
> > It looks good to me, by the way.
> 
> In the blk-zoned.c in this way it is easier to bisect if/when the problem
> 
> comes.

Oh okay.  That makes sense.

Thanks, Chaitanya.
