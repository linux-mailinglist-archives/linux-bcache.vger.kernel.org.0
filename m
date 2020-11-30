Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0367F2C8BBD
	for <lists+linux-bcache@lfdr.de>; Mon, 30 Nov 2020 18:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387411AbgK3Rwm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 30 Nov 2020 12:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728321AbgK3Rwm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 30 Nov 2020 12:52:42 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E7A5C0613CF
        for <linux-bcache@vger.kernel.org>; Mon, 30 Nov 2020 09:51:56 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id b63so10873684pfg.12
        for <linux-bcache@vger.kernel.org>; Mon, 30 Nov 2020 09:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zGnnwAdYWjtdhwju8NcFhzJcpMrWjZbZM1FQN8kVDHg=;
        b=uHFgX+4AVkQgx7faklPk/rXQ2t3jemQG+USPU79z1ylyowIu+ubayCfcNDVRC61F46
         uOUat2OPBdrNV3C5cxDEKe++AihqW2dfiUMqAR9SSzg0pWNoXwmF7ToC19r922VtbWfr
         GnZWjiz7MwL36CuNP5a8PBDGbSSHjoQJPhU96VUc/2DTZ+eLKM46XkcINUXSEgzoNRVJ
         B4aqmPEpPNtUoWXOmsYcqMofGY6tX4m12lDRyTKN8UmgHif1BP6ersB+G7h3Dqe1BMla
         /i9GORlNNRTQ9/OCndNw/5vShhAGl68QelubQRXFJANa6CdOvdZreY4YnK+uQ2CRP4+S
         bZWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zGnnwAdYWjtdhwju8NcFhzJcpMrWjZbZM1FQN8kVDHg=;
        b=suNQ+5apxYY2CQh+wgKBRQ2EZVKVoglwWPbSGcUwKQMyHrm9M4ERnDLxRW4kjpZgqB
         J1FbNiEtrds1PXDy58RA0xDmaTO7AZw7KN4IlWu27Atc52NhWqPumP8jXFZJOdyXWoqo
         tb4hGJNBQKp9He+iI6uq5/21XGJfqd0tWY7x/bhB33+RNYTuwj0zmX0P6Mmks6jHALbV
         MzadyytuiwV37Xy7Ivo7HXSiWz5vviwEYt5lV5ZYQXL9dfpR+ZyZ13ReMv04aihC0QYL
         d3O396bloGmUpaBLed9st3J8XV/QfudwRI38dLVPDRAloAYAeZnAVBWp/OzN62w9Kc+C
         A4VQ==
X-Gm-Message-State: AOAM533GHFMykPrgKE85M2Fiwt2ErxjH/3T7Xql+/9kgCbjHOqKZ7oux
        lcSuwfbz/rQVJEW3lI+qQ9dZPA==
X-Google-Smtp-Source: ABdhPJwMTZsLj5SnQFza8cXET/WnIEE6pVW7Y7fE9/cYA5ZaExgItRAY6sgUO5JUjmSVf3YBKD1+nQ==
X-Received: by 2002:a62:ed01:0:b029:19a:a667:9925 with SMTP id u1-20020a62ed010000b029019aa6679925mr17651943pfh.35.1606758716075;
        Mon, 30 Nov 2020 09:51:56 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id w18sm17681748pfi.216.2020.11.30.09.51.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Nov 2020 09:51:55 -0800 (PST)
Subject: Re: merge struct block_device and struct hd_struct v4
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
        Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jan Kara <jack@suse.cz>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        dm-devel@redhat.com, Jan Kara <jack@suse.com>,
        linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org
References: <20201128161510.347752-1-hch@lst.de>
 <20201130171915.GA1499@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e67ffb20-ce91-a3a7-e1f7-6fd32334abc4@kernel.dk>
Date:   Mon, 30 Nov 2020 10:51:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201130171915.GA1499@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 11/30/20 10:19 AM, Christoph Hellwig wrote:
> On Sat, Nov 28, 2020 at 05:14:25PM +0100, Christoph Hellwig wrote:
>> A git tree is available here:
>>
>>     git://git.infradead.org/users/hch/block.git bdev-lookup
>>
>> Gitweb:
>>
>>     http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/bdev-lookup
> 
> I've updated the git tree with the set_capacity_and_notify change
> suggested by Jan, a commit log typo fix and the Reviewed-by tags.
> 
> Jens, can you take a look and potentially merge the branch?  That would
> really help with some of the pending work.

Done, queued up for 5.11.

-- 
Jens Axboe

