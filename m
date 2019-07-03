Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2085E74C
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jul 2019 17:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfGCPDb (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 3 Jul 2019 11:03:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45458 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfGCPDb (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 3 Jul 2019 11:03:31 -0400
Received: by mail-pf1-f193.google.com with SMTP id r1so1403676pfq.12;
        Wed, 03 Jul 2019 08:03:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UpKw9Zxoxe8rge03LP2f6638eI4p8y0legXuCWEjCsI=;
        b=ICppt5lQcaGL40MP1SDxZWfyOqWoiNJPn1viioHfqHinIW1hSNeOuOwgJDGYA5OIVx
         l1PJ+JXCfjC04S3ZxA/2dyjVjb34vc5q4i/z6V1kPeMMnoaMidgtGjzagEEqiJw9pg5/
         PRvRzDQJaahpjVW/xrhy+/PyNRusP2RzUTzy4iJiP3+i9FQGI1Q9+AmaG/G+Ccvv8ASx
         99NQM61TL0AUnXNfAl3pLUGFqBH4i9O710nCA4qdz0NBYY9OO7XRlawjZa9OOdHWWP0u
         jnBI40lY3GuxQamj/mkqFTibIbtapuq6clhjAxHuDsLCqUmeU83LhYxp8MKb+l53sa1z
         /Y4Q==
X-Gm-Message-State: APjAAAWaFZ8uBLxegWcwfZSvyVzNzJECrE3itJV/jyNBLcdS+BkdF4jT
        6emqME+uy7NylDTuq8w8Bo5w1JFRfZs=
X-Google-Smtp-Source: APXvYqyR83vJcx0j6MO8XREogh+x0eiGjMP5GA+fOFSvZ7wYxEQvReZcXoMSmjWhPLNI5xsp0sPuDQ==
X-Received: by 2002:a17:90a:ff17:: with SMTP id ce23mr13281431pjb.47.1562166210114;
        Wed, 03 Jul 2019 08:03:30 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id o13sm2450376pje.28.2019.07.03.08.03.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 08:03:29 -0700 (PDT)
Subject: Re: [PATCH V3 1/9] block: add a helper function to read nr_setcs
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, linux-scsi@vger.kernel.org
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <26917678-fd82-b6c8-761e-220bc7d3b179@acm.org>
Date:   Wed, 3 Jul 2019 08:03:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.1
MIME-Version: 1.0
In-Reply-To: <20190702174236.3332-2-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 7/2/19 10:42 AM, Chaitanya Kulkarni wrote:
> +/* Helper function to read the bdev->bd_part->nr_sects */
> +static inline sector_t bdev_nr_sects(struct block_device *bdev)
> +{
> +	return part_nr_sects_read(bdev->bd_part);
> +}

Is the comment above bdev_nr_sects() really useful or should it be left out?

Thanks,

Bart.
