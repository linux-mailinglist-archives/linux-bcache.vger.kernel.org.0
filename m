Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA22B41A2C1
	for <lists+linux-bcache@lfdr.de>; Tue, 28 Sep 2021 00:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237613AbhI0WO4 (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 27 Sep 2021 18:14:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237237AbhI0WOz (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 27 Sep 2021 18:14:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 014C460F94;
        Mon, 27 Sep 2021 22:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632780797;
        bh=aUkvMSo84Ts+2hyfPmGVIgM4abSwV67b0JY7DU1pVzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CR3ThJMTzNN7IxGCoQ9SihnqkQkkv3F41YJaAr67klqD8ay7cRcSeppUUhh/8+7PQ
         DFxOyaBzoI962F2usbjfziq1easTinlTyXoLnTwCKEIgdylqvj9h8QEVuaeDIXyhCf
         8pRA7I8t7831enPRtpE/358VVKwNsUwrPG5b/lRH5qyH1IXU821Yn+C1LYzW65TQiM
         Kr2pNyLsYwmCCd+A88QwrYslEh5QjuzWUx1TBVYz6/tBtiRBBMVllLOKUI3Il17WX7
         FhuTQ1Q9A8S1JL3ILSV0TNBfSOS3l81jmsFCnMM1Pvg1VT7bDaBh2KmwsWKeTC3U9m
         OIVZBum14ZcHw==
Date:   Mon, 27 Sep 2021 15:13:12 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        sagi@grimberg.me, vishal.l.verma@intel.com,
        dan.j.williams@intel.com, dave.jiang@intel.com,
        ira.weiny@intel.com, konrad.wilk@oracle.com, roger.pau@citrix.com,
        boris.ostrovsky@oracle.com, jgross@suse.com,
        sstabellini@kernel.org, minchan@kernel.org, ngupta@vflare.org,
        senozhatsky@chromium.org, xen-devel@lists.xenproject.org,
        nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/10] nvme-multipath: add error handling support for
 add_disk()
Message-ID: <20210927221312.GD387558@dhcp-10-100-145-180.wdc.com>
References: <20210927220039.1064193-1-mcgrof@kernel.org>
 <20210927220039.1064193-4-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927220039.1064193-4-mcgrof@kernel.org>
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On Mon, Sep 27, 2021 at 03:00:32PM -0700, Luis Chamberlain wrote:
> +	/*
> +	 * test_and_set_bit() is used because it is protecting against two nvme
> +	 * paths simultaneously calling device_add_disk() on the same namespace
> +	 * head.
> +	 */
>  	if (!test_and_set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags)) {
> -		device_add_disk(&head->subsys->dev, head->disk,
> -				nvme_ns_id_attr_groups);
> +		rc = device_add_disk(&head->subsys->dev, head->disk,
> +				     nvme_ns_id_attr_groups);
> +		if (rc)
> +			return;
> +		set_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);

No need to set_bit() here since the test_and_set_bit() already took care
of that.
