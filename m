Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F482487EF
	for <lists+linux-bcache@lfdr.de>; Mon, 17 Jun 2019 17:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbfFQPxX (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 17 Jun 2019 11:53:23 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45021 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727750AbfFQPxX (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 17 Jun 2019 11:53:23 -0400
Received: by mail-pf1-f193.google.com with SMTP id t16so5902291pfe.11;
        Mon, 17 Jun 2019 08:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gXsovZAgUyQ9Ty69klcD+ox6RNqz4eapQ67u71/jxLw=;
        b=oW04Vm9I79kx39Hz6g+2ia002XqzATHXq+MiU7x1rqmDm4JHYkZE0s1qwgH01wZ05c
         qGokLTgRh40FzO0FB71QvdnPHrpcYLzAgMtJa3O/1NN0sugQ9z3kSCOgtWsE7mS85b8a
         r/KwD1drEFa+HObp090mpk0yTPfxXfgLWcf/tgRJ77ja82v8q+ri1clv9QzFYrIT0G0e
         6QRTP04/lNnHmvD85IpTTAmyjAs2MqbNQ/PyO0iOKFVV+BKCr1n9VXP273LdltWwPX/r
         OYIwKI7yjjvb0LfaDgSFM/4CHk7ufdcTJSNnG6lS8I4USz0OOhHgLnsJ3YspVoMS/Fqq
         mlDQ==
X-Gm-Message-State: APjAAAVjzp+DsFdHSIJemORvVIIzGLsolplHhBn6nF9R9MgW9RZTVgkQ
        zLHTNSeM1n2YOWh6WmmtnF4=
X-Google-Smtp-Source: APXvYqzVRHXVx0/b/6p4DpzamNEZbH2jKVEW2/Zscs/7h+WfG98gI/k+uGI+Iiu379YnHFYmIHxqAw==
X-Received: by 2002:aa7:914e:: with SMTP id 14mr62815947pfi.136.1560786802411;
        Mon, 17 Jun 2019 08:53:22 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b29sm7698905pfr.159.2019.06.17.08.53.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 08:53:21 -0700 (PDT)
Subject: Re: [PATCH V2 0/7] block: use right accessor to read nr_setcs
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, kent.overstreet@gmail.com,
        jaegeuk@kernel.org, damien.lemoal@wdc.com
References: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a5a43553-69f1-fb99-fbfe-d0cb676a6cfa@acm.org>
Date:   Mon, 17 Jun 2019 08:53:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617012832.4311-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/16/19 6:28 PM, Chaitanya Kulkarni wrote:
> Changes from V1:-
> 
> 1. Drop the target_pscsi patch. (Bart)
> 2. Remove rcu locking which is not needed. (Bart)
> 
> Chaitanya Kulkarni (7):
>    block: add a helper function to read nr_setcs
>    blk-zoned: update blkdev_nr_zones() with helper
>    blk-zoned: update blkdev_report_zone() with helper
>    blk-zoned: update blkdev_reset_zones() with helper
>    bcache: update cached_dev_init() with helper
>    f2fs: use helper in init_blkz_info()
>    blktrace: use helper in blk_trace_setup_lba()
> 
>   block/blk-zoned.c         | 12 ++++++------
>   drivers/md/bcache/super.c |  2 +-
>   fs/f2fs/super.c           |  2 +-
>   include/linux/blkdev.h    | 10 ++++++++++
>   kernel/trace/blktrace.c   |  2 +-
>   5 files changed, 19 insertions(+), 9 deletions(-)

My feedback about the pscsi_get_blocks() was misleading: what I meant is 
that it is not necessary to introduce RCU locking in that function. I 
think that using bdev_nr_sects() or part_nr_sects_read() to read 
nr_sects in that function is useful.

Is there any reason that the following Xen macro has not been converted?

#define vbd_sz(_v)	((_v)->bdev->bd_part ? \
			 (_v)->bdev->bd_part->nr_sects : \
			  get_capacity((_v)->bdev->bd_disk))

Thanks,

Bart.
