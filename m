Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E994191EBF
	for <lists+linux-bcache@lfdr.de>; Wed, 25 Mar 2020 02:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCYB5e (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 24 Mar 2020 21:57:34 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43840 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgCYB5d (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 24 Mar 2020 21:57:33 -0400
Received: by mail-pg1-f193.google.com with SMTP id u12so369314pgb.10
        for <linux-bcache@vger.kernel.org>; Tue, 24 Mar 2020 18:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TKJZ2EyBquqQdCJAnm1fCNBjZhc0RxxaKIcaLb96M+M=;
        b=JnWILv2XSxfFTkMsH5mZuj5NnVozL/ZKc+7f71oIWMRPfGsIeYA6zZgC/ezMw2wCag
         BaXewB8VnN8AHgS1++FR3sZ0C/zRnOvO3pHr/ZM4hg265WD36bc+Clu5qHukst6kDcb/
         zrVg+VC77vF9xCktekjV2CYj3dAd7pzCCZBIWiUrUyh19nGev9kwBCsF741mEuy5kryn
         JNvU2oUn5LnmxJCwy5XgU72yvb3HLRv4Ix1gpjW2ekYmP5Hilis0pO/OrhDtgo2n2ChV
         rNM9sR1fHMNE93JXPR+UHckPvgXWA4ILqBI7ih+rmGyiFsgmTaIpY6ZUuff9BkL9B9ax
         5qBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TKJZ2EyBquqQdCJAnm1fCNBjZhc0RxxaKIcaLb96M+M=;
        b=r2VDjS47e9E+ZrnfFyMbrn0piS8Ita9bpcbEDXtYeTx/v+o4plzVYDpmfpN5tUTk1O
         hajdiD/BMriePiR+ctnqp7B+qAXoaU+37OA6ISyD0TwKp8SHSFWxhylG0YqxkeXaZqRL
         Ss1vweYLsQscl9lRdYAH8Ht0f2wljxQl4L+/W2kHgp6VSlyJdcwNdDFCYItnhgDcjdmj
         ignzZxlGj1J6SUi5s+NOS+O/5ncvjDTl+Ur5U8mrwbNM/T3TgqxMI384+oSlFquUoeHP
         bSGM5awmb5Bes+uW09mYgwTCI2eCVpLFsmqGAr3HrnzjRp0fJtcLEoKz1czysWlQ08kx
         UJcQ==
X-Gm-Message-State: ANhLgQ1l2SvKn81BM0U8IVbiyjO+CY6w9Zu5Y0REoNB3AFwQz052NGsE
        lVlqWFfVdUIDcYMcG7W2JnuNCA==
X-Google-Smtp-Source: ADFU+vtMD0QarqHpIYqdQGPD9iq0GlbQ+BMyJgFUmsWmIJRUUXJs+yNdZUVjO/GzZZMZssOCOFj7Iw==
X-Received: by 2002:a63:f002:: with SMTP id k2mr747467pgh.14.1585101451389;
        Tue, 24 Mar 2020 18:57:31 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y9sm13323532pfo.135.2020.03.24.18.57.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Mar 2020 18:57:30 -0700 (PDT)
Subject: Re: [PATCH 1/1] bcache: remove dupplicated declaration from btree.h
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        kbuild test robot <lkp@intel.com>
References: <20200325013057.114340-1-colyli@suse.de>
 <20200325013057.114340-2-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6577c33f-5e57-f34a-8bbc-a4c17e124e11@kernel.dk>
Date:   Tue, 24 Mar 2020 19:57:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200325013057.114340-2-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/24/20 7:30 PM, Coly Li wrote:
> Commit ab544165dc2d ("bcache: move macro btree() and btree_root()
> into btree.h") makes two duplicated declaration into btree.h,
> 	typedef int (btree_map_keys_fn)();
> 	int bch_btree_map_keys();
> 
> The kbuild test robot <lkp@intel.com> detects and reports this
> problem and this patch fixes it by removing the duplicated ones.
> 
> Fixes: ab544165dc2d ("bcache: move macro btree() and btree_root() into btree.h")

Applied, but I fixed up the commit sha, not sure where yours is from?

-- 
Jens Axboe

