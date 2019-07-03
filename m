Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE4855D8DB
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jul 2019 02:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfGCAaN (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 20:30:13 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:38409 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727294AbfGCAaM (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 20:30:12 -0400
Received: by mail-oi1-f194.google.com with SMTP id v186so559112oie.5;
        Tue, 02 Jul 2019 17:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RHRpDgwuVrgTUZrVeC/DWcppQoZgBwyoX6yUIa5nxw0=;
        b=uEw2tqOOvpzS7lgKZQ1UE6HLk03zu/ltUnP+fEoKgiIzoSOQ1CznTyBFvQHqSe8gWD
         ooB1noO/sOpR9opDZyb5Jhx22qlulHHFhz/w0nQt+2scVy45cKOVFnsEt84G8Hdg8AMh
         bSpT40ce4fwwNLJCExWMA2az+nVBgeQ5DLo0LWdoYGAVesfMxKEBANFUgqEBEJRFmoTZ
         5kO3/0y6ofZ1sHIWaN2fO37s/g37+o1BIqI8uz8d/t4ftbIyBqZwd3TlZYDDcbmlarO7
         tq9YVQo9XHW+Ag8i0wJSx9aQ/oUwsAnop/8u1yIY4a88wjrq3GZtAtDSh9l8mgYyb6ZN
         6v/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RHRpDgwuVrgTUZrVeC/DWcppQoZgBwyoX6yUIa5nxw0=;
        b=ECEWS6m6jMRWXGZpFyUi5x8w5Urpzfksn9u86XkMxCrXO7ahybz6AJ6ANRGuv1oWRC
         pyVGtibdNLzA4FTXDpNM9v8siaPGhqMm11JOJXRTlZESbie49suGlf0DJCdogsk8hPXL
         oBoEyK/2qqPEyP75GoK9Kaazm3U7B0SqGipQTmjWhuCIdaLA0ejlkJl3hcxSQv7OeDoJ
         knTHZ2/Ci23RvoMzcJ+nqnzfqIcWAt5a33Nrp+PwQDYtPpTYR7NbhRhh7L4Kj61DOfdZ
         7AySKgB8eiqir3Zy5KlYqmnvy/QbOpG41bF2v00LIzKGbWyf9Q6c77RE1iHE9SdoOYut
         fGjw==
X-Gm-Message-State: APjAAAVKrG2lrgvjEGNO2Gp77MRz4QVya0ijFO8YH6MHA4ScJKw53u6j
        XILDsPYJQgUkxLNJs9Mq+9dlbVds6VU=
X-Google-Smtp-Source: APXvYqyhFQu0ujFbRWIByTBXPw8+e+SmZdlz5g9lzglnzFcMkXFOtvOW/RoMDBBBeY2YXLDY5aO+Eg==
X-Received: by 2002:a63:296:: with SMTP id 144mr34044286pgc.141.1562113431489;
        Tue, 02 Jul 2019 17:23:51 -0700 (PDT)
Received: from localhost ([123.213.206.190])
        by smtp.gmail.com with ESMTPSA id t9sm164581pji.18.2019.07.02.17.23.50
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 17:23:50 -0700 (PDT)
Date:   Wed, 3 Jul 2019 09:23:47 +0900
From:   Minwoo Im <minwoo.im.dev@gmail.com>
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc:     linux-block@vger.kernel.org, colyli@suse.de,
        linux-bcache@vger.kernel.org, linux-btrace@vger.kernel.org,
        xen-devel@lists.xenproject.org, kent.overstreet@gmail.com,
        yuchao0@huawei.com, jaegeuk@kernel.org, damien.lemoal@wdc.com,
        konrad.wilk@oracle.com, roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 4/9] blk-zoned: update blkdev_reset_zones() with helper
Message-ID: <20190703002347.GE15705@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190702174236.3332-5-chaitanya.kulkarni@wdc.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 19-07-02 10:42:30, Chaitanya Kulkarni wrote:
> This patch updates the blkdev_reset_zones() with newly introduced
> helper function to read the nr_sects from block device's hd_parts with
> the help of part_nr_sects_read().

Chaitanya,

Are the first three patches split for a special reason?  IMHO, it could
be squashed into a single one.

It looks good to me, by the way.

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
