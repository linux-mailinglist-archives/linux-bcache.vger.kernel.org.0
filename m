Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341955D8AA
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Jul 2019 02:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfGCA0x (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Jul 2019 20:26:53 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40054 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGCA0w (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Jul 2019 20:26:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so268890pfp.7;
        Tue, 02 Jul 2019 17:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SyGygRvF7tQ7FctjsD/yOuoqXJYtp+eTsFPKMcnatrs=;
        b=NQdsT26kXB30wQgDd6j8wAXc3lqYA4/QUO5XOL6I5fkc1jnphiYqUeyGX6P6OFkBQ7
         PlEpA9WenC+UpJJzbdKxtHQOH2KRMejNADumCvIOtw/AkQEbWhHRoDdX4sB1fE1bDX3G
         gs9JSvVI2g2BlldCrIJ8keNsHGUigpT9Zw0weSM5IOOJ3H9vZ2p4ZQf6nAltXIqWdto4
         YkA6NLmw9ck0MpNkqZzpLCfa0Hp2n2J2GA3Vq9GgMOQiAZyt/0ehAQyHCcqcfG+6jygd
         OaHnoMOeLseIg4q4efZQZ9Z7nejF9blCnwnb9wSxDxzy6eSf5WjTFgAAMEgUeiA8u0wp
         Ob5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SyGygRvF7tQ7FctjsD/yOuoqXJYtp+eTsFPKMcnatrs=;
        b=oX3vUtN1yAMhnSsdnRfV3mjplwzRap7toHIv0csfLbXdD9kV8DoLBAQBedheCdRyVx
         RiED43aqhCH0Tj7up/6OdlGxCiJAkH9ky8UrZILxp2a6i3IYfi6KlB7T/EilwBNuQnUB
         WNXPY8flRxIE+7iABVpee1HdVPq6XhsMgWdBu++trwiw/d1Q91qr5mkqXaQE8zLcIz6H
         DhSEcyzXwMa4PNQAm/ScKu13GjykvLw/iVlYRQuxhO8zQpP6Boiygq/XgZuIqAmhbPzg
         ZGIcLiQelABGSKCxYjig37Nf1HnF5VWcfTa5lhsmPd6r0OWBCuhf3BzD/zw/sXM5uz4H
         4W2A==
X-Gm-Message-State: APjAAAXnxEyudNL60zW6Gil5k2mATUjetqofeZoQFH3HCigbnDfOhIMi
        0Jo08yjOqztvvr7Q8WAcN4g=
X-Google-Smtp-Source: APXvYqw7GdQJdCoAqYc4RVF3EPx6ukesK6aJ9nue2vSbAqwQbZroX7LfXxNcySyQWP7wMZbNvVuzvw==
X-Received: by 2002:a17:90a:5207:: with SMTP id v7mr8302656pjh.127.1562113270544;
        Tue, 02 Jul 2019 17:21:10 -0700 (PDT)
Received: from localhost ([123.213.206.190])
        by smtp.gmail.com with ESMTPSA id h11sm212092pfn.170.2019.07.02.17.21.09
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 17:21:09 -0700 (PDT)
Date:   Wed, 3 Jul 2019 09:21:07 +0900
From:   Minwoo Im <minwoo.im.dev@gmail.com>
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Cc:     linux-block@vger.kernel.org, colyli@suse.de,
        linux-bcache@vger.kernel.org, linux-btrace@vger.kernel.org,
        xen-devel@lists.xenproject.org, kent.overstreet@gmail.com,
        yuchao0@huawei.com, jaegeuk@kernel.org, damien.lemoal@wdc.com,
        konrad.wilk@oracle.com, roger.pau@citrix.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, Minwoo Im <minwoo.im.dev@gmail.com>
Subject: Re: [PATCH V3 3/9] blk-zoned: update blkdev_report_zone() with helper
Message-ID: <20190703002107.GD15705@minwoo-desktop>
References: <20190702174236.3332-1-chaitanya.kulkarni@wdc.com>
 <20190702174236.3332-4-chaitanya.kulkarni@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190702174236.3332-4-chaitanya.kulkarni@wdc.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 19-07-02 10:42:29, Chaitanya Kulkarni wrote:
> This patch updates the blkdev_report_zone(s)() with newly introduced
> helper function to read the nr_sects from block device's hd_parts with
> the help of part_nr_sects_read().

It looks good to me.

Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
